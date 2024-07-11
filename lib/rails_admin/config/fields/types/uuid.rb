

require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Uuid < RailsAdmin::Config::Fields::Types::String
          RailsAdmin::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
