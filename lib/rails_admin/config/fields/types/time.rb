require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Time < RailsAdmin::Config::Fields::Types::Datetime
          RailsAdmin::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
