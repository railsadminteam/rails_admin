require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Types::Datetime
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 60
          @datepicker_options = {}
          @i18n_scope = [:time, :formats]

          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:strftime_format) do
            "%I:%M%p"
          end
        end
      end
    end
  end
end