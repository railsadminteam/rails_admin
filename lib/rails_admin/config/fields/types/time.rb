require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Types::Datetime
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :strftime_format do
            '%H:%M'
          end
        end
      end
    end
  end
end
