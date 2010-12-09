require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class String < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_css_class) do
            length > 100 ? "bigString" : "smallString"
          end

          register_instance_option(:column_width) do
            length > 100 ? 250 : 180
          end

          register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end

          # Accessor for field's help text displayed below input field.
          register_instance_option(:help) do
            text = required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
            text += " #{length} "
            text += length == 1 ? I18n.translate("admin.new.one_char") : I18n.translate("admin.new.many_chars")
            text
          end

          register_instance_option(:searchable?) do
            true
          end

          register_instance_option(:sortable?) do
            true
          end
        end
      end
    end
  end
end