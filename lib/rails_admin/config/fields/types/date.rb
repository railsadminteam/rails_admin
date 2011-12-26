require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Date < RailsAdmin::Config::Fields::Types::Datetime
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @format = :long
          @i18n_scope = [:date, :formats]
          @js_plugin_options = {
            "showTime" => false,
          }

          def parse_input(params)
            params[name] = self.class.normalize(params[name], localized_date_format).to_date if params[name].present?
          end
        end
      end
    end
  end
end
