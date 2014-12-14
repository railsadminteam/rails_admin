module RailsAdmin
  module Adapters
    module ActiveRecord
      class Property
        attr_reader :property, :model

        def initialize(property, model)
          @property = property
          @model = model
        end

        def name
          property.name.to_sym
        end

        def pretty_name
          property.name.to_s.tr('_', ' ').capitalize
        end

        def type
          if model.serialized_attributes[property.name.to_s]
            :serialized
          else
            property.type
          end
        end

        def length
          property.limit
        end

        def nullable?
          property.null
        end

        def serial?
          model.primary_key == property.name
        end

        def association?
          false
        end

        def read_only?
          false
        end
      end
    end
  end
end
