module RailsAdmin
  class FormBuilder < ActionView::Helpers::FormBuilder
    
    def render(action)
      @template.instance_variable_get(:@model_config).send(action).with(:form => self, :object => @object, :view => @template).visible_groups.map do |fieldset|
        fieldset_for(fieldset)
      end.join.html_safe +
      @template.render(:partial => 'submit_buttons')
    end
    
    def fieldset_for(fieldset)
      if (fields = fieldset.fields.map{ |f| f.with(:form => self, :object => @object, :view => @template) }.select(&:visible?)).length > 0
        @template.content_tag :fieldset do
          @template.content_tag(:legend, fieldset.label + (fieldset.help.present? ? @template.content_tag(:small, fieldset.help) : '')) +
          fields.map{ |field| field_wrapper_for(field) }.join.html_safe
        end
      end
    end
    
    def field_wrapper_for field
      @template.content_tag(:div, :class => "clearfix field #{'error' if field.errors.present?}", :id => field.dom_id + '_field') do
        label(field.method_name, field.label) +
        input_for(field)
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
        field.pretty_value.html_safe
      else
        field.render.html_safe
      end
    end
  end
end