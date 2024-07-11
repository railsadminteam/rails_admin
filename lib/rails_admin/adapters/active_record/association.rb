

module RailsAdmin
  module Adapters
    module ActiveRecord
      class Association
        attr_reader :association, :model

        def initialize(association, model)
          @association = association
          @model = model
        end

        def name
          association.name.to_sym
        end

        def pretty_name
          name.to_s.tr('_', ' ').capitalize
        end

        def type
          association.macro
        end

        def field_type
          if polymorphic?
            :polymorphic_association
          else
            :"#{association.macro}_association"
          end
        end

        def klass
          if options[:polymorphic]
            polymorphic_parents(:active_record, association.active_record.name.to_s, name) || []
          else
            association.klass
          end
        end

        def primary_key
          return nil if polymorphic?

          case type
          when :has_one
            association.klass.primary_key
          else
            association.association_primary_key
          end.try(:to_sym)
        end

        def foreign_key
          association.foreign_key.to_sym
        end

        def foreign_key_nullable?
          return true if foreign_key.nil? || type != :has_many

          (column = klass.columns_hash[foreign_key.to_s]).nil? || column.null
        end

        def foreign_type
          options[:foreign_type].try(:to_sym) || :"#{name}_type" if options[:polymorphic]
        end

        def foreign_inverse_of
          nil
        end

        def key_accessor
          case type
          when :has_many, :has_and_belongs_to_many
            :"#{name.to_s.singularize}_ids"
          when :has_one
            :"#{name}_id"
          else
            foreign_key
          end
        end

        def as
          options[:as].try :to_sym
        end

        def polymorphic?
          options[:polymorphic] || false
        end

        def inverse_of
          options[:inverse_of].try :to_sym
        end

        def read_only?
          (klass.all.instance_exec(&scope).readonly_value if scope.is_a?(Proc) && scope.arity == 0) ||
            association.nested? ||
            false
        end

        def nested_options
          model.nested_attributes_options.try { |o| o[name.to_sym] }
        end

        def association?
          true
        end

        delegate :options, :scope, to: :association, prefix: false
        delegate :polymorphic_parents, to: RailsAdmin::AbstractModel
      end
    end
  end
end
