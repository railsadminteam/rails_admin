require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Enum < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:edit_partial) do
            :form_enumeration
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil} enum",
              :value => value
            }
          end

          register_instance_option(:enum_method) do
            @enum_method ||= (bindings[:object].respond_to?("#{name}_enum") ? "#{name}_enum" : name)
          end

          register_instance_option(:enum) do
            bindings[:object].send(self.enum_method)
          end
        end
      end
    end
  end
end