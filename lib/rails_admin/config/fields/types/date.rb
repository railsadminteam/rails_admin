require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Date < RailsAdmin::Config::Fields::Types::Datetime
          RailsAdmin::Config::Fields::Types.register(self)

          def parse_value(value)
            ::Date.parse(value) if value.present?
          end

          register_instance_option :date_format do
            :long
          end

          register_instance_option :datepicker_options do
            {
              allowInput: true,
              altFormat: flatpickr_format,
            }
          end

          register_instance_option :i18n_scope do
            %i[date formats]
          end

          register_instance_option :html_attributes do
            {
              required: required?,
              size: 18,
            }
          end
        end
      end
    end
  end
end
