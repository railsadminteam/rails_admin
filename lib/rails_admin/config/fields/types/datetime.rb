

require 'rails_admin/config/fields/base'
require 'rails_admin/support/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          def parse_value(value)
            ::Time.zone.parse(value)
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name]
          end

          register_instance_option :filter_operators do
            %w[default between today yesterday this_week last_week] + (required? ? [] : %w[_separator _not_null _null])
          end

          def filter_options
            super.merge(
              datetimepicker_options: datepicker_options,
            )
          end

          register_instance_option :date_format do
            :long
          end

          register_instance_option :i18n_scope do
            %i[time formats]
          end

          register_instance_option :strftime_format do
            ::I18n.t(date_format, scope: i18n_scope, raise: true)
          rescue ::I18n::ArgumentError
            '%B %d, %Y %H:%M'
          end

          register_instance_option :flatpickr_format do
            RailsAdmin::Support::Datetime.to_flatpickr_format(strftime_format)
          end

          register_instance_option :datepicker_options do
            {
              allowInput: true,
              enableTime: true,
              altFormat: flatpickr_format,
            }
          end

          register_instance_option :html_attributes do
            {
              required: required?,
              size: 22,
            }
          end

          register_instance_option :sort_reverse? do
            true
          end

          register_instance_option :queryable? do
            false
          end

          register_instance_option :formatted_value do
            time = (value || default_value)
            if time
              ::I18n.l(time, format: strftime_format)
            else
              ''.html_safe
            end
          end

          register_instance_option :partial do
            :form_datetime
          end

          register_deprecated_instance_option :momentjs_format do
            ActiveSupport::Deprecation.warn('The momentjs_format configuration option is deprecated, please use flatpickr_format with corresponding values here: https://flatpickr.js.org/formatting/')
          end

          def form_value
            value&.in_time_zone&.strftime('%FT%T') || form_default_value
          end
        end
      end
    end
  end
end
