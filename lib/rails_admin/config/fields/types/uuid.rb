require 'rails_admin/config/fields/base'

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
