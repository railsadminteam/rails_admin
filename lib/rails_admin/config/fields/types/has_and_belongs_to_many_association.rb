# frozen_string_literal: true

require 'rails_admin/config/fields/collection_association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class HasAndBelongsToManyAssociation < RailsAdmin::Config::Fields::CollectionAssociation
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)
        end
      end
    end
  end
end
