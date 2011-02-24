require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:date_format) do
            :long
          end

          register_instance_option(:formatted_value) do
            unless (time = value).nil?
              unless format = strftime_format
                I18n.l(time, :format => date_format, :default => I18n.l(time, :format => date_format, :locale => :en))
              else
                time.strftime(format)
              end
            else
              "".html_safe
            end
          end

          register_instance_option(:strftime_format) do
            false
          end
        end
      end
    end
  end
end
