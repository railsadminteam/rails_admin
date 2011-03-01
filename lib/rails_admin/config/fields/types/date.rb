require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Date < RailsAdmin::Config::Fields::Types::Datetime
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 120
          @format = :long
          @js_plugin_options = {
            "showTime" => false,
          }
          @i18n_scope = [:date, :formats]

          def parse_input(params)
            params[name] = self.class.normalize(params[name], localized_date_format) if params[name]
          end
        end
      end
    end
  end
end