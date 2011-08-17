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

        def self.default_items_per_page
          ActiveSupport::Deprecation.warn("'#{self.name}.default_items_per_page' is deprecated, use 'RailsAdmin::Config.default_items_per_page' instead", caller)
          RailsAdmin::Config.default_items_per_page
        end

        def self.default_items_per_page=(value)
          ActiveSupport::Deprecation.warn("'#{self.name}.default_items_per_page=' is deprecated, use 'RailsAdmin.config{|c| c.default_items_per_page = #{value}}' instead", caller)
          RailsAdmin.config do |config|
            config.default_items_per_page = value
          end
        end

        register_instance_option :filters do
          []
        end

        # Number of items listed per page
        register_instance_option(:items_per_page) do
          RailsAdmin::Config.default_items_per_page
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
