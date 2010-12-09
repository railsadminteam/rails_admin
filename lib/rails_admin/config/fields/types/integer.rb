require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Integer < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_css_class) do
            serial? ? "id" : "int"
          end

          register_instance_option(:column_width) do
            serial? ? 46 : 80
          end

          register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end

          register_instance_option(:searchable?) do
            false
          end

          register_instance_option(:sortable?) do
            true
          end
        end
      end
    end
  end
end