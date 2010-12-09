require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Date < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_css_class) do
            "date"
          end

          register_instance_option(:column_width) do
            90
          end

          register_instance_option(:date_format) do
            :long
          end

          register_instance_option(:formatted_value) do
            unless (time = value).nil?
              I18n.l(time, :format => date_format, :default => I18n.l(time, :format => date_format, :locale => :en))
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
            false
          end
        end
      end
    end
  end
end