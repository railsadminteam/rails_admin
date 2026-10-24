# frozen_string_literal: true

module RailsAdmin
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ::RailsAdmin::ApplicationHelper

    # Bounds a nested form for an association that can reach itself. Counting repeats
    # of one association, rather than depth, leaves distinct models uncapped.
    MAX_NESTED_FORM_RECURSION = 3

    def generate(options = {})
      without_field_error_proc_added_div do
        options.reverse_merge!(
          action: @template.controller.params[:action],
          model_config: @template.instance_variable_get(:@model_config),
          nested_in: false,
        )

        object_infos +
          visible_groups(options[:model_config], generator_action(options[:action], options[:nested_in])).collect do |fieldset|
            fieldset_for fieldset, options[:nested_in]
          end.join.html_safe +
          (options[:nested_in] ? '' : @template.render(partial: 'rails_admin/main/submit_buttons'))
      end
    end

    def fieldset_for(fieldset, nested_in)
      fields = fieldset.with(
        form: self,
        object: @object,
        view: @template,
        controller: @template.controller,
      ).visible_fields
      return if fields.empty?

      @template.content_tag :fieldset do
        contents = []
        contents << @template.content_tag(:legend, %(<i class="fas fa-chevron-#{fieldset.active? ? 'down' : 'right'}"></i> #{fieldset.label}).html_safe, style: fieldset.name == :default ? 'display:none' : '')
        contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
        contents << fields.collect { |field| field_wrapper_for(field, nested_in) }.join
        contents.join.html_safe
      end
    end

    def field_wrapper_for(field, nested_in)
      # do not show nested field if the target is the origin
      return if nested_field_association?(field, nested_in)

      @template.content_tag(:div, class: "control-group row mb-3 #{field.type_css_class} #{field.css_class} #{'error' if field.errors.present?}", id: "#{dom_id(field)}_field") do
        if field.label
          label(field.method_name, field.label, class: 'col-sm-2 col-form-label text-md-end') +
            (field.nested_form ? field_for(field) : input_for(field))
        else
          field.nested_form ? field_for(field) : input_for(field)
        end
      end
    end

    def input_for(field)
      css = 'col-sm-10 controls'
      css += ' has-error' if field.errors.present?
      @template.content_tag(:div, class: css) do
        field_for(field) +
          errors_for(field) +
          help_for(field)
      end
    end

    def errors_for(field)
      field.errors.present? ? @template.content_tag(:span, field.errors.to_sentence, class: 'help-inline text-danger') : ''.html_safe
    end

    def help_for(field)
      field.help.present? ? @template.content_tag(:div, field.help, class: 'form-text') : ''.html_safe
    end

    def field_for(field)
      field.read_only? ? @template.content_tag(:div, field.pretty_value, class: 'form-control-static') : field.render
    end

    # Rails' per-child hook; .fields is the node the JavaScript and the stylesheet work on.
    def fields_for_nested_model(name, object, fields_options, block)
      content = super
      return content unless content

      @template.content_tag :div, content, class: 'fields',
                                           data: {'nested-new' => (true if object.new_record?)}
    end

    # The association's children, then an inert <template> for adding one more. The
    # children are told which association they are nested in, so the controls inside
    # them can answer for themselves.
    def nested_fields_for(field, &block)
      # fields_for answers nil for a singular association with no child yet.
      children = fields_for(field.name, nil, {nested_in: field}, &block) || ''.html_safe
      children + (nested_add_allowed?(field) ? nested_template_for(field, &block) : ''.html_safe)
    end

    # data-nested-add is what lets the JavaScript find the template from outside the control group.
    def link_to_add(label, field_or_name, html_options = {})
      # A Field arrives wrapped in a Proxyable::Proxy, so ask what it is not. Only a
      # Field can say whether adding is allowed; a bare name is taken at its word.
      by_name = field_or_name.is_a?(Symbol) || field_or_name.is_a?(String)
      return ''.html_safe if !by_name && !nested_add_allowed?(field_or_name)

      name = by_name ? field_or_name : field_or_name.name
      options = nested_button_options(html_options, 'add_nested_fields')
      options[:data] = (options[:data] || {}).merge('nested-add' => name)
      @template.content_tag(:button, label, options)
    end

    # Also emits the _destroy input the button drives. A row that is already saved can
    # only be removed where the association allows it; one that is not yet saved always
    # can, so that a row just added can be taken back.
    def link_to_remove(label, html_options = {})
      nested_in = options[:nested_in]
      return ''.html_safe if nested_in && !nested_in.nested_form[:allow_destroy] && !object.new_record?

      hidden_field(:_destroy, value: false) +
        @template.content_tag(:button, label, nested_button_options(html_options, 'remove_nested_fields'))
    end

    def object_infos
      model_config = RailsAdmin.config(object)
      model_label = model_config.label
      object_label =
        if object.new_record?
          I18n.t('admin.form.new_model', name: model_label)
        else
          # A record whose label method has nothing to say is named after the
          # model label here, where the rest of the admin uses the class name.
          model_config.object_label(object, "#{model_label} ##{object.id}")
        end

      %(<span style="display:none" class="object-infos" data-model-label="#{model_label}" data-object-label="#{CGI.escapeHTML(object_label.to_s)}"></span>).html_safe
    end

    def jquery_namespace(field)
      %(#{'#modal ' if @template.controller.params[:modal]}##{dom_id(field)}_field)
    end

    def dom_id(field)
      (@dom_id ||= {})[field.name] ||=
        [
          @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, ''),
          options[:index],
          field.method_name,
        ].reject(&:blank?).join('_')
    end

    def dom_name(field)
      (@dom_name ||= {})[field.name] ||= %(#{@object_name}#{options[:index] && "[#{options[:index]}]"}[#{field.method_name}]#{field.is_a?(Config::Fields::Association) && field.multiple? ? '[]' : ''})
    end

    def hidden_field(method, options = {})
      return super unless method == :id && object.id.is_a?(Array)

      super method, {value: RailsAdmin.config(object.class).abstract_model.format_id(object.id)}
    end

  protected

    def nested_add_allowed?(field)
      !!field.inline_add &&
        @object_name.to_s.scan("[#{field.name}_attributes]").size < MAX_NESTED_FORM_RECURSION
    end

    def nested_template_for(field, &block)
      # Tagged by depth, never by association name: a name-tagged placeholder is a
      # prefix of the ones in the templates nested inside it.
      index = ("new_#{nesting_depth + 1}_#{field.name}" if field.multiple?)
      # Rails wraps a single record for a collection association by itself.
      body = fields_for(field.name, field.associated_model_config.abstract_model.new,
                        {nested_in: field, child_index: index}.compact, &block)
      @template.content_tag :template, body,
                            data: {'nested-template' => field.name, 'nested-index' => index}.compact
    end

    def nesting_depth
      @object_name.to_s.scan('_attributes]').size
    end

    def nested_button_options(html_options, css_class)
      options = html_options.symbolize_keys
      options[:type] ||= 'button'
      options[:class] = [options[:class].presence, css_class].compact.join(' ')
      options
    end

    def generator_action(action, nested)
      if nested
        action = :nested
      elsif @template.request.format == 'text/javascript'
        action = :modal
      end

      action
    end

    def visible_groups(model_config, action)
      model_config.send(action).with(
        form: self,
        object: @object,
        view: @template,
        controller: @template.controller,
      ).visible_groups
    end

    def without_field_error_proc_added_div
      default_field_error_proc = ::ActionView::Base.field_error_proc
      begin
        ::ActionView::Base.field_error_proc = proc { |html_tag, _instance| html_tag }
        yield
      ensure
        ::ActionView::Base.field_error_proc = default_field_error_proc
      end
    end

  private

    def nested_field_association?(field, nested_in)
      nested_in.presence &&
        (field.name == nested_in.inverse_of ||
         (field.inverse_of.presence && field.inverse_of == nested_in.name &&
          @template.instance_variable_get(:@model_config).abstract_model == field.abstract_model))
    end
  end
end
