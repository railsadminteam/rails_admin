

module RailsAdmin
  module Adapters
    module Mongoid
      class Association
        attr_reader :association, :model

        delegate :autosave?, to: :association

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
          case macro.to_sym
          when :belongs_to, :referenced_in, :embedded_in
            :belongs_to
          when :has_one, :references_one, :embeds_one
            :has_one
          when :has_many, :references_many, :embeds_many
            :has_many
          when :has_and_belongs_to_many, :references_and_referenced_in_many
            :has_and_belongs_to_many
          else
            raise "Unknown association type: #{macro.inspect}"
          end
        end

        def field_type
          if polymorphic?
            :polymorphic_association
          else
            :"#{type}_association"
          end
        end

        def klass
          if polymorphic? && %i[referenced_in belongs_to].include?(macro)
            polymorphic_parents(:mongoid, association.inverse_class_name, name) || []
          else
            association.klass
          end
        end

        def primary_key
          case type
          when :belongs_to, :has_and_belongs_to_many
            association.primary_key.to_sym
          else
            :_id
          end
        end

        def foreign_key
          return if embeds?

          begin
            association.foreign_key.to_sym
          rescue StandardError
            nil
          end
        end

        def foreign_key_nullable?
          return if foreign_key.nil?

          true
        end

        def foreign_type
          return unless polymorphic? && %i[referenced_in belongs_to].include?(macro)

          association.inverse_type.try(:to_sym) || :"#{name}_type"
        end

        def foreign_inverse_of
          return unless polymorphic? && %i[referenced_in belongs_to].include?(macro)

          inverse_of_field.try(:to_sym)
        end

        def key_accessor
          case macro.to_sym
          when :has_many
            :"#{name.to_s.singularize}_ids"
          when :has_one
            :"#{name}_id"
          when :embedded_in, :embeds_one, :embeds_many
            nil
          else
            foreign_key
          end
        end

        def as
          association.as.try :to_sym
        end

        def polymorphic?
          association.polymorphic? && %i[referenced_in belongs_to].include?(macro)
        end

        def inverse_of
          association.inverse_of.try :to_sym
        end

        def read_only?
          false
        end

        def nested_options
          nested = nested_attributes_options.try { |o| o[name] }
          if !nested && %i[embeds_one embeds_many].include?(macro.to_sym) && !cyclic?
            raise <<~MSG
              Embedded association without accepts_nested_attributes_for can't be handled by RailsAdmin,
              because embedded model doesn't have top-level access.
              Please add `accepts_nested_attributes_for :#{association.name}' line to `#{model}' model.
            MSG
          end

          nested
        end

        def association?
          true
        end

        def macro
          association.try(:macro) || association.class.name.split('::').last.underscore.to_sym
        end

        def embeds?
          %i[embeds_one embeds_many].include?(macro)
        end

      private

        def inverse_of_field
          association.respond_to?(:inverse_of_field) && association.inverse_of_field
        end

        def cyclic?
          association.respond_to?(:cyclic?) ? association.cyclic? : association.cyclic
        end

        delegate :nested_attributes_options, to: :model, prefix: false
        delegate :polymorphic_parents, to: RailsAdmin::AbstractModel
      end
    end
  end
end
