require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class String < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          # Display a colorpicker widget instead of text input.
          # Todo: refactor to a dedicated field type
          register_instance_option(:color?) do
            false
          end

          register_instance_option(:help) do
            text = (required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")) + '. '

            # Length requirement isn't necessary to display in case a colorpicker is rendered
            unless color?
              text += "#{length} "
              text += length == 1 ? I18n.translate("admin.new.one_char") : I18n.translate("admin.new.many_chars")
              text += ". "
            end

            text
          end
          
          register_instance_option(:pretty_value) do
            bindings[:view].truncate(formatted_value.to_s, :length => 60)
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil} #{color? ? 'color' : nil}",
              :maxlength => length,
              :size => [50, length.to_i].min,
              :style => "width:#{column_width}px",
              :value => value,
            }
           end

          register_instance_option(:partial) do
            color? ? :form_colorpicker : :form_field
          end
        end
      end
    end
  end
end
