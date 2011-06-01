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
        
        # list of searchable fields.
        # needs a hash with key = column_type and values = list of fields, with table name, suitable for search.
        # ex.: {:boolean => ['players.injured'], :string => ['players.name', 'teams.name']}
        register_instance_option(:searchable_fields) do
          model_config = RailsAdmin.config(self.abstract_model)
          base_table_name = model_config.abstract_model.model.table_name
          base_properties = self.abstract_model.properties
          @searchable_fields ||= @fields.inject(Hash.new { |hash, key| hash[key] = Array.new }) do |collector, field|
            if field.search_with
              field_table_name = field.association? ? field.associated_model_config.abstract_model.model.table_name : base_table_name
              associated_model_methods = case field.search_with
              when :self
                collector[field.type] << "#{base_table_name}.#{field.name}" # force use of base table_name
              when :all # valid only for associations
                if field.association?
                  field.associated_model_config.list.fields.each do |f| 
                    collector[f.type] << "#{field_table_name}.#{f.name}"
                  end
                else
                  raise('search_with :all for non-association fields doesn\'t make sense')
                end
              else
                properties = field.association? ? field.associated_model_config.abstract_model.properties : base_properties
                [field.search_with].flatten.each do |field_name| 
                  properties.select do |p| 
                    p[:name] == field_name
                  end.each do |p|
                    collector[p[:type]] << "#{field_table_name}.#{field_name}"
                  end
                end
              end
            end
            collector
          end
        end
      end
    end
  end
end
