# frozen_string_literal: true

require 'rails_admin/adapters/reflection'
require 'rails_admin/adapters/mongoid/association'
require 'rails_admin/adapters/mongoid/property'

module RailsAdmin
  module Adapters
    module Mongoid
      class Reflection < RailsAdmin::Adapters::Reflection
        def primary_key
          '_id'
        end

        def associations
          model.relations.values.collect do |association|
            Association.new(association, model)
          end
        end

        def properties
          fields = model.fields.reject { |_name, field| DISABLED_COLUMN_TYPES.include?(field.type.to_s) }
          fields.collect { |_name, field| Property.new(field, model) }
        end

        def base_class
          klass = model
          klass = klass.superclass while klass.hereditary?
          klass
        end

        def table_name
          model.collection_name.to_s
        end

        def encoding
          Encoding::UTF_8
        end

        def embedded?
          associations.detect { |a| a.macro == :embedded_in }
        end

        def cyclic?
          model.cyclic?
        end

        def adapter_supports_joins?
          false
        end

        def belongs_to_required_by_default
          ::Mongoid.belongs_to_required_by_default
        end
      end
    end
  end
end
