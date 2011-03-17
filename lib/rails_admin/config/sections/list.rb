require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/labelable'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the list view
      class List < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::Hideable
        include RailsAdmin::Config::Labelable

        def initialize(parent)
          super(parent)
          # Populate @fields instance variable with model's properties
          @fields = RailsAdmin::Config::Fields.factory(self)
          @fields.each do |f|
            if f.association? && f.type != :belongs_to_association
              f.hide
            end
          end
        end

        # Default items per page value used if a model level option has not
        # been configured
        cattr_accessor :default_items_per_page
        @@default_items_per_page = 20

        # Number of items listed per page
        register_instance_option(:items_per_page) do
          RailsAdmin::Config::Sections::List.default_items_per_page
        end

        register_instance_option(:sort_by) do
          # TODO
          # Once composite-primary-keys branch is merged
          # we should use parent.abstract_model.primary_keys.first as the default
          :id
        end

        register_instance_option(:sort_reverse?) do
          true # By default show latest first
        end
      end
    end
  end
end
