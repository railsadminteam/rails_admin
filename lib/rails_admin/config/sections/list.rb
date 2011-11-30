require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the list view
      class List < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields

        def initialize(parent)
          super(parent)
          # Populate @fields instance variable with model's properties
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            if f.association? && !f.kind_of?(RailsAdmin::Config::Fields::Types::BelongsToAssociation)
              f.visible false
            end
          end
        end

        register_instance_option :filters do
          []
        end

        # Number of items listed per page
        register_instance_option :items_per_page do
          RailsAdmin::Config.default_items_per_page
        end

        register_instance_option :sort_by do
          parent.abstract_model.model.primary_key
        end

        register_instance_option :sort_reverse? do
          true # By default show latest first
        end
      end
    end
  end
end
