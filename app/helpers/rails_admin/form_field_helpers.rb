module RailsAdmin
  module FormFieldHelpers

    def fieldset_for(fieldset, nested_in)
      if (fields = fieldset.with(:form => self, :object => @object, :view => @template, :controller => @template.controller).visible_fields).length > 0
        @template.content_tag :fieldset do
          contents = []
          contents << @template.content_tag(:legend, %{<i class="icon-chevron-#{(fieldset.active? ? 'down' : 'right')}"></i> #{fieldset.label}}.html_safe, :style => "#{fieldset.name == :default ? 'display:none' : ''}")
          contents << @template.content_tag(:p, fieldset.help) if fieldset.help.present?
          contents << fields.map { |field| field_wrapper_for(field, nested_in) }.join
          contents.join.html_safe
        end
      end
    end

    def field_wrapper_for(field, nested_in)
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
        field.nested_form ? field_for(field) : input_for(field)
      end
    end

    def input_for(field)
      @template.content_tag(:div, :class => 'controls') do
        field_for(field) +
          errors_for(field) +
          help_for(field)
      end
    end

    def errors_for(field)
      field.errors.present? ? @template.content_tag(:span, "#{field.label} #{field.errors.to_sentence}", :class => 'help-inline') : ''.html_safe
    end

    def help_for(field)
      field.help.present? ? @template.content_tag(:p, field.help, :class => 'help-block') : ''.html_safe
    end

    def field_for(field)
      if field.read_only?
        field.pretty_value.to_s.html_safe
      else
        field.render
      end
    end
  end
end
