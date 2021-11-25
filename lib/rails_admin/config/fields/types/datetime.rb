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

          register_instance_option :momentjs_format do
            RailsAdmin::Support::Datetime.to_momentjs(strftime_format)
          end

          register_instance_option :datepicker_options do
            {
              showTodayButton: true,
              format: momentjs_format,
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
            if time = (value || default_value)
              ::I18n.l(time, format: strftime_format)
            else
              ''.html_safe
            end
          end

          register_instance_option :partial do
            :form_datetime
          end

          def form_value
            value&.in_time_zone&.strftime('%FT%T') || form_default_value
          end
        end
      end
    end
  end
end
