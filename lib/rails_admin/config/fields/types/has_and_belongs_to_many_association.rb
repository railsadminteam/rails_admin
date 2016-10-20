require 'rails_admin/config/fields/types/has_many_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasAndBelongsToManyAssociation < RailsAdmin::Config::Fields::Types::HasManyAssociation
          RailsAdmin::Config::Fields::Types.register(self)
          def parse_value(value)
            value
          end
        end
      end
    end
  end
end
