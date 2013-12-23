module RailsAdmin
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ::NestedForm::BuilderMixin
    include FormFieldHelpers

    def generate(options = {})
      without_field_error_proc_added_div do
        options.reverse_merge!(
          :action => @template.controller.params[:action],
          :model_config => @template.instance_variable_get(:@model_config),
          :nested_in => false
        )

        object_infos + visible_groups(options[:model_config], generator_action(options[:action], options[:nested_in])).map do |fieldset|
          fieldset_for fieldset, options[:nested_in]
        end.join.html_safe + (options[:nested_in] ? '' : @template.render(:partial => 'rails_admin/main/submit_buttons'))
      end
    end

        def object_infos
      model_config = RailsAdmin.config(object)
      model_label = model_config.label
      object_label = if object.new_record?
                       I18n.t('admin.form.new_model', :name => model_label)
                     else
                       object.send(model_config.object_label_method).presence || "#{model_config.label} ##{object.id}"
                     end
      %{<span style="display:none" class="object-infos" data-model-label="#{model_label}" data-object-label="#{CGI.escapeHTML(object_label)}"></span>}.html_safe
    end

    def jquery_namespace(field)
      %{#{'#modal ' if @template.controller.params[:modal]}##{dom_id(field)}_field}
    end

    def dom_id(field)
      (@dom_id ||= {})[field.name] ||=
        [
          @object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, ''),
          options[:index],
          field.method_name
      ].reject(&:blank?).join('_')
    end

    def dom_name(field)
      (@dom_name ||= {})[field.name] ||= %{#{@object_name}#{options[:index] && "[#{options[:index]}]"}[#{field.method_name}]#{field.is_a?(Config::Fields::Association) && field.multiple? ? '[]' : ''}}
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
        :form => self,
        :object => @object,
        :view => @template,
        :controller => @template.controller
      ).visible_groups
    end

    def without_field_error_proc_added_div
      default_field_error_proc = ::ActionView::Base.field_error_proc
      begin
        ::ActionView::Base.field_error_proc = proc { |html_tag, instance| html_tag }
        yield
      ensure
        ::ActionView::Base.field_error_proc = default_field_error_proc
      end
    end
  end
end
