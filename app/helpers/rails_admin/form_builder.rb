ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe }

module RailsAdmin
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include ::NestedForm::BuilderMixin
    
    def generate(options = {})
      options.reverse_merge!({
        :action => @template.controller.params[:action],
        :model_config => @template.instance_variable_get(:@model_config),
        :nested_in => false
      })
      
      options[:model_config].send(options[:action]).with(:form => self, :object => @object, :view => @template).visible_groups.map do |fieldset|
        fieldset_for fieldset, options[:nested_in]
      end.join.html_safe +
      (options[:nested_in] ? '' : @template.render(:partial => 'submit_buttons'))
    end

    def fieldset_for fieldset, nested_in
      if (fields = fieldset.fields.map{ |f| f.with(:form => self, :object => @object, :view => @template) }.select(&:visible?)).length > 0
        @template.content_tag :fieldset do
          @template.content_tag(:legend, fieldset.label.html_safe + (fieldset.help.present? ? @template.content_tag(:small, fieldset.help) : '')) +
          fields.map{ |field| field_wrapper_for(field, nested_in) }.join.html_safe
        end
      end
    end

    def field_wrapper_for field, nested_in
      # do not show nested field if the target is the origin
      unless field.inverse_of.presence && field.inverse_of == nested_in
        # raw field content for nested form
        if field.nested_form
          field_for(field)
        else
          @template.content_tag(:div, :class => "clearfix field #{field.type_css_class} #{field.css_class} #{'error' if field.errors.present?}", :id => "#{dom_id(field)}_field") do
            label(field.method_name, field.label) +
            input_for(field)
          end
        end
      end
    end

    def input_for field
      @template.content_tag(:div, :class => 'input') do
        field_for(field) +
        errors_for(field) +
        help_for(field)
      end
    end

    def errors_for field
      field.errors.present? ? @template.content_tag(:span, "#{field.label} #{field.errors.first}", :class => 'help-inline') : ''
    end

    def help_for field
      field.help.present? ? @template.content_tag(:span, field.help, :class => 'help-block') : ''
    end

    def field_for field
      if field.read_only
        field.pretty_value.to_s.html_safe
      else
        field.render
      end
    end
    
    def javascript_for(field, options = {}, &block)
      %{
        <script type="text/javascript">
          jQuery(function($) {
            if(!$("#{js_namespace(field)}").parents(".fields_blueprint").length) {
              if(#{options[:modal] == false ? '!$("#modal").length' : 'true'}) {
                #{@template.capture(&block)}
              }
            }
          });
        </script>
      }.html_safe
    end
    
    def js_namespace field
      "#{(@template.controller.params[:modal] ? '#modal ' : '')}##{dom_id(field)}_field"
    end
    
    def dom_id field
      (@dom_id ||= {})[field.name] ||= 
        [
          @object_name.sub('][', '_').sub(']', '').sub('[', '_'),
          options[:index],
          field.method_name
        ].reject(&:blank?).join('_')
    end
    
    def dom_name field
      (@dom_name ||= {})[field.name] ||= "#{@object_name}#{options[:index] && "[#{options[:index]}]"}[#{field.method_name}]#{field.is_a?(Config::Fields::Types::HasManyAssociation) ? '[]' : ''}"
    end
  end
end
