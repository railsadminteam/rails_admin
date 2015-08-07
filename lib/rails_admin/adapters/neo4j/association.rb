module RailsAdmin
  module Adapters
    module Neo4j
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
          case type.to_sym
          when :has_one, :has_many
            type.to_sym
            fail("Unknown association type: #{type.inspect}")
          end
        end

        def klass
          if polymorphic? #&& [:referenced_in, :belongs_to].include?(type)
            if association.model_class.is_a?(Array)
              association.model_class
            elsif association.model_class == false
              []
            end
          else
            association.target_class_names[0].constantize.to_s
          end
        end

        def primary_key
          :uuid
        end

        def foreign_key
          return unless [:embeds_one, :embeds_many].exclude?(type.to_sym)
          association.foreign_key.to_sym rescue nil
        end

        def foreign_type
          return unless polymorphic? && [:referenced_in, :belongs_to].include?(type)
          association.inverse_type.try(:to_sym) || :"#{name}_type"
        end

        def foreign_inverse_of
          return unless polymorphic? && [:referenced_in, :belongs_to].include?(type)
          inverse_of_field.try(:to_sym)
        end

        def as
          true
        end

        def polymorphic?
          association.model_class == false || association.model_class.is_a?(Array)
        end

        def inverse_of
          #association.inverse_of.try :to_sym
          nil
        end

        def read_only?
          false
        end

        def nested_options
          nested = nested_attributes_options.try { |o| o[name] }
          if !nested && [:embeds_one, :embeds_many].include?(type.to_sym) && !association.cyclic
            fail <<-MSG.gsub(/^\s+/, '')
            Embbeded association without accepts_nested_attributes_for can't be handled by RailsAdmin,
            because embedded model doesn't have top-level access.
            Please add `accepts_nested_attributes_for :#{association.name}' line to `#{model}' model.
            MSG
          end
          nested
        end

        def association?
          true
        end

        def eager_loadable?
          true
        end

      private

        def inverse_of_field
          association.respond_to?(:inverse_of_field) && association.inverse_of_field
        end

        delegate :type, :options, to: :association, prefix: false
        delegate :nested_attributes_options, to: :model, prefix: false
        delegate :polymorphic_parents, to: RailsAdmin::AbstractModel
      end
    end
  end
end
