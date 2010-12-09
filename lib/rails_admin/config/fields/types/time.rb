require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_css_class) do
            "time"
          end

          register_instance_option(:column_width) do
            60
          end

          register_instance_option(:formatted_value) do
            unless (time = value).nil?
              time.strftime(strftime_format)
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

          register_instance_option(:strftime_format) do
            "%I:%M%p"
          end
        end
      end
    end
  end
end