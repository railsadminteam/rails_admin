require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Types::Datetime
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :date_format do
            :short
          end

          register_instance_option :i18n_scope do
            [:admin, :time, :formats]
          end

          register_instance_option :datepicker_options do
            {
              showTodayButton: true,
              format: parser.to_momentjs,
            }
          end

          register_instance_option :html_attributes do
            {
              required: required?,
              size: 10,
            }
          end
        end
      end
    end
  end
end
