require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Types::Datetime
          RailsAdmin::Config::Fields::Types.register(self)

          def parse_value(value)
            super(value).try(:utc)
          end

          register_instance_option :strftime_format do
            '%H:%M'
          end

          register_instance_option :partial do
            :form_time
          end

          register_instance_option :html_attributes do
            {
              required: required?,
              size: 8,
            }
          end
        end
      end
    end
  end
end
