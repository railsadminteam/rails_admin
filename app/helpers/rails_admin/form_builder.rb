module RailsAdmin
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ::NestedForm::BuilderMixin
    include ::RailsAdmin::ApplicationHelper

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
      return unless (fields = fieldset.with(form: self, object: @object, view: @template, controller: @template.controller).visible_fields).length > 0
      @template.content_tag :fieldset do
        contents = []
        contents << @template.content_tag(:legend, %(<i class="icon-chevron-#{(fieldset.active? ? 'down' : 'right')}"></i> #{fieldset.label}).html_safe, style: "#{fieldset.name == :default ? 'display:none' : ''}")
        contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
        contents << fields.collect { |field| field_wrapper_for(field, nested_in) }.join
        contents.join.html_safe
      end
    end

    def field_wrapper_for(field, nested_in)
      if field.label
        # do not show nested field if the target is the origin
        unless nested_field_association?(field, nested_in)
          @template.content_tag(:div, class: "form-group control-group #{field.type_css_class} #{field.css_class} #{'error' if field.errors.present?}", id: "#{dom_id(field)}_field") do
            label(field.method_name, capitalize_first_letter(field.label), class: 'col-sm-2 control-label') +
              (field.nested_form ? field_for(field) : input_for(field))
          end
        end
      else
        field.nested_form ? field_for(field) : input_for(field)
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
      field.help.present? ? @template.content_tag(:span, field.help, class: 'help-block') : ''.html_safe
    end

    def field_for(field)
      if field.read_only?
        field.pretty_value.to_s.html_safe
      else
        field.render
      end
    end

    def object_infos
      model_config = RailsAdmin.config(object)
      model_label = model_config.label
      object_label = begin
        if object.new_record?
          I18n.t('admin.form.new_model', name: model_label)
        else
          object.send(model_config.object_label_method).presence || "#{model_config.label} ##{object.id}"
        end
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

  protected

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
      field.inverse_of.presence && nested_in.presence && field.inverse_of == nested_in.name &&
        (@template.instance_variable_get(:@model_config).abstract_model == field.associated_model_config.abstract_model ||
         field.name == nested_in.inverse_of)
    end
  end
end
