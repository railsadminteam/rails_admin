module RailsAdmin
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ::NestedForm::BuilderMixin

    def generate(options = {})
      without_field_error_proc_added_div do
        options.reverse_merge!({
          :action => @template.controller.params[:action],
          :model_config => @template.instance_variable_get(:@model_config),
          :nested_in => false
        })

        if options[:nested_in]
          action = :nested
        elsif @template.request.format == 'text/javascript'
          action = :modal
        else
          action = options[:action]
        end

        groups = options[:model_config].send(action).with(:form => self, :object => @object, :view => @template, :controller => @template.controller).visible_groups

        object_infos +
        groups.map do |fieldset|
          fieldset_for fieldset, options[:nested_in]
        end.join.html_safe +
        (options[:nested_in] ? '' : @template.render(:partial => 'rails_admin/main/submit_buttons'))
      end
    end

    def fieldset_for fieldset, nested_in
      if (fields = fieldset.with(:form => self, :object => @object, :view => @template, :controller => @template.controller).visible_fields).length > 0
        @template.content_tag :fieldset do
          contents = []
          contents << @template.content_tag(:legend, %{<i class="icon-chevron-#{(fieldset.active? ? 'down' : 'right')}"></i> #{fieldset.label}}.html_safe, :style => "#{fieldset.name == :default ? 'display:none' : ''}")
          contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
          contents << fields.map{ |field| field_wrapper_for(field, nested_in) }.join
          contents.join.html_safe
        end
      end
    end

    def field_wrapper_for field, nested_in
      if field.label
        # do not show nested field if the target is the origin
        unless field.inverse_of.presence && field.inverse_of == nested_in &&
          @template.instance_variable_get(:@model_config).abstract_model == field.associated_model_config.abstract_model
          @template.content_tag(:div, :class => "control-group #{field.type_css_class} #{field.css_class} #{'error' if field.errors.present?}", :id => "#{dom_id(field)}_field") do
            label(field.method_name, field.label, :class => 'control-label') +
            (field.nested_form ? field_for(field) : input_for(field))
          end
        end
      else
        (field.nested_form ? field_for(field) : input_for(field))
      end
    end

    def input_for field
      @template.content_tag(:div, :class => 'controls') do
        field_for(field) +
        errors_for(field) +
        help_for(field)
      end
    end

    def errors_for field
      field.errors.present? ? @template.content_tag(:span, "#{field.label} #{field.errors.to_sentence}", :class => 'help-inline') : ''.html_safe
    end

    def help_for field
      field.help.present? ? @template.content_tag(:p, field.help, :class => 'help-block') : ''.html_safe
    end

    def field_for field
      if field.read_only?
        field.pretty_value.to_s.html_safe
      else
        field.render
      end
    end

    def object_infos
      model_config = RailsAdmin.config(object)
      model_label = model_config.label
      object_label = (object.new_record? ? I18n.t('admin.form.new_model', :name => model_label) : object.send(model_config.object_label_method).presence || "#{model_config.label} ##{object.id}")
      %{<span style="display:none" class="object-infos" data-model-label="#{model_label}" data-object-label="#{object_label}"></span>}.html_safe
    end

    def jquery_namespace field
      %{#{(@template.controller.params[:modal] ? '#modal ' : '')}##{dom_id(field)}_field}
    end

    def dom_id field
      (@dom_id ||= {})[field.name] ||=
        [
          @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, ""),
          options[:index],
          field.method_name
        ].reject(&:blank?).join('_')
    end

    def dom_name field
      (@dom_name ||= {})[field.name] ||= %{#{@object_name}#{options[:index] && "[#{options[:index]}]"}[#{field.method_name}]#{field.is_a?(Config::Fields::Association) && field.multiple? ? '[]' : ''}}
    end

    protected
      def without_field_error_proc_added_div
        default_field_error_proc = ::ActionView::Base.field_error_proc
        begin
          ::ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag }
          yield
        ensure
          ::ActionView::Base.field_error_proc = default_field_error_proc
        end
      end
  end
end
