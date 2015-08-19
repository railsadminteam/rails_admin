require 'rails_admin/config/fields/base'
require 'rails_admin/support/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          def parser
            @parser ||= RailsAdmin::Support::Datetime.new(date_format, i18n_scope)
          end

          def parse_input(params)
            params[name] = parser.parse_string(params[name]) if params[name]
          end

          register_instance_option :date_format do
            :long
          end

          register_instance_option :i18n_scope do
            [:time, :formats]
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
              size: 22,
            }
          end

          register_instance_option :sort_reverse? do
            true
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

          register_instance_option :strftime_format do
            parser.localized_format i18n_scope
          end
        end
      end
    end
  end
end
