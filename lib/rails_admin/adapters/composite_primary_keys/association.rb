

module RailsAdmin
  module Adapters
    module CompositePrimaryKeys
      class Association < RailsAdmin::Adapters::ActiveRecord::Association
        def field_type
          if type == :belongs_to && association.foreign_key.is_a?(Array)
            :composite_keys_belongs_to_association
          else
            super
          end
        end

        def primary_key
          return nil if polymorphic?

          value = association.association_primary_key

          if value.is_a? Array
            :id
          else
            value.to_sym
          end
        end

        def foreign_key
          if association.foreign_key.is_a? Array
            association.foreign_key.map(&:to_sym)
          else
            super
          end
        end

        def key_accessor
          if type == :belongs_to && foreign_key.is_a?(Array)
            :"#{name}_id"
          else
            super
          end
        end
      end
    end
  end
end
