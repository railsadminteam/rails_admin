# frozen_string_literal: true

module RailsAdmin
  module Adapters
    # The half of an adapter that describes a model: what its attributes and
    # associations are, what the store calls them, and what the model layer says
    # about them.
    #
    # One instance per model, held by the AbstractModel that composes it. A
    # reflection answers questions about the model and never reads or writes a
    # record; the store it does reach for is the schema, not the data.
    class Reflection
      attr_reader :abstract_model

      def initialize(abstract_model)
        @abstract_model = abstract_model
      end

      delegate :model, to: :abstract_model

      # Stores that neither qualify nor quote identifiers use the names as they
      # are; ActiveRecord asks its connection instead.
      def quoted_table_name
        table_name
      end

      def quote_column_name(name)
        name
      end

      def pretty_name
        model.model_name.human
      end

      def human_attribute_name(name)
        model.human_attribute_name(name)
      end

      # Whether the model makes the given attribute mandatory, either through a
      # validation or through the options of a belongs_to association.
      #
      # +context+ is +:create+, +:update+ or +nil+ and is matched against the
      # +:on+ option of a validation. Adapters may override this when their ORM
      # expresses requiredness differently.
      def attribute_required?(name, context)
        !!(required_by_validation?(name, context) || required_by_association?(name))
      end

      # Options of the length validation defined on the given attribute, if any.
      def attribute_length_options(name)
        model.validators_on(name).detect { |validator| validator.kind == :length }.try(&:options) || {}
      end

      # The values of an enum defined on the given attribute, or nil.
      #
      # Only stores with a native enum concept answer this; the rest leave enums
      # to the model, which is what Types::Enum asks about instead.
      def attribute_enum_values(_name)
        nil
      end

      # A throwaway record, for asking what an instance of this model responds to
      # when no real one is at hand.
      #
      # Instantiating one is wasteful and runs the model's initialization, but
      # method_defined? would miss anything served through method_missing, so the
      # original behavior is kept until there is a reason to narrow it.
      def dummy_record
        model.new
      end

    private

      def required_by_validation?(name, context)
        model.validators_on(name).detect do |validator|
          !(validator.options[:allow_nil] || validator.options[:allow_blank]) &&
            %i[presence numericality attachment_presence].include?(validator.kind) &&
            (validator.options[:on] == context || validator.options[:on].blank?) &&
            (validator.options[:if].blank? && validator.options[:unless].blank?)
        end
      end

      def required_by_association?(name)
        model.reflect_on_all_associations(:belongs_to).detect do |association|
          next unless association.name == name

          required = association.options[:required] if association.options.key?(:required)
          required = !association.options[:optional] if association.options.key?(:optional) && required.nil?
          required.nil? ? belongs_to_required_by_default : required
        end
      end
    end
  end
end
