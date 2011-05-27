require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Enum < RailsAdmin::Config::Fields::Base          
          RailsAdmin::Config::Fields::Types::register(self)
          
          register_instance_option(:partial) do
            :form_enumeration
          end
          
          register_instance_option(:help) do
            text = required? ? I18n.translate("admin.new.required") : I18n.translate("admin.new.optional")
          end
          
          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil} enum",
              :value => value
            }
          end
        end
      end
    end
  end
end