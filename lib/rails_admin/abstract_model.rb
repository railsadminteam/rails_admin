# frozen_string_literal: true

require 'rails_admin/adapters/statement_builder'
require 'rails_admin/criteria/path'
require 'rails_admin/criteria/period'
require 'rails_admin/support/datetime'

module RailsAdmin
  class AbstractModel
    # Moved to RailsAdmin::Adapters::StatementBuilder, which is where the
    # adapters that subclass it now live. Kept so that out-of-tree adapters
    # subclassing the old name keep working.
    StatementBuilder = RailsAdmin::Adapters::StatementBuilder

    cattr_accessor :all
    attr_reader :adapter, :model_name, :repository

    class << self
      def reset
        @@all = nil
      end

      def all(adapter = nil)
        @@all ||= Config.models_pool.collect { |m| new(m) }.compact
        adapter ? @@all.select { |m| m.adapter == adapter } : @@all
      end

      alias_method :old_new, :new
      def new(m)
        m = m.constantize unless m.is_a?(Class)
        (am = old_new(m)).model && am.adapter ? am : nil
      rescue *([LoadError, NameError] + (defined?(ActiveRecord) ? ['ActiveRecord::NoDatabaseError'.constantize, 'ActiveRecord::ConnectionNotEstablished'.constantize] : []))
        puts "[RailsAdmin] Could not load model #{m}, assuming model is non existing. (#{$ERROR_INFO})" unless Rails.env.test?
        nil
      end

      @@polymorphic_parents = {}

      def polymorphic_parents(adapter, model_name, name)
        @@polymorphic_parents[adapter.to_sym] ||= {}.tap do |hash|
          all(adapter).each do |am|
            am.associations.select(&:as).each do |association|
              (hash[[association.klass.to_s.underscore, association.as].join('_').to_sym] ||= []) << am.model
            end
          end
        end
        @@polymorphic_parents[adapter.to_sym][[model_name.to_s.underscore, name].join('_').to_sym]
      end

      # For testing
      def reset_polymorphic_parents
        @@polymorphic_parents = {}
      end

      # A classifier answers "what is this attribute, in RailsAdmin's terms" for
      # attributes whose meaning comes from the model layer rather than from the
      # store: attachment libraries, enums and the like. Without it every field
      # factory has to reach past the adapter and inspect the model class itself.
      #
      # The block receives the model class and a property, and returns a Role or
      # nil to defer to the next classifier. Classifiers run last in, first out.
      # A classifier must not ask the property for its role, or it recurses.
      def register_classifier(&block)
        classifiers.unshift(block)
      end

      def classifiers
        @classifiers ||= []
      end

      def classify(model, property)
        classifiers.each do |classifier|
          role = classifier.call(model, property)
          return role if role
        end
        nil
      end
    end

    # What a property turned out to be, beyond its storage type.
    #
    # +kind+ names the thing (:shrine, :paperclip, :enum, ...), +name+ is the
    # field name it should be surfaced under, and +children+ lists the columns
    # that back it and therefore should not be shown on their own.
    Role = Struct.new(:kind, :name, :children, keyword_init: true) do
      def initialize(kind:, name:, children: [])
        super
      end
    end

    def initialize(model_or_model_name)
      @model_name = model_or_model_name.to_s
      ancestors = model.ancestors.collect(&:to_s)
      if ancestors.include?('ActiveRecord::Base') && !model.abstract_class? && model.table_exists?
        initialize_active_record
      elsif ancestors.include?('Mongoid::Document')
        initialize_mongoid
      end
    end

    # do not store a reference to the model, does not play well with ActiveReload/Rails3.2
    def model
      @model_name.constantize
    end

    # Everything that reaches the store is the repository's, and reaches it
    # through here so that callers keep talking to one object.
    delegate :new, :get, :first, :all, :count, :destroy, :scoped, :where,
             :each_associated_children, :format_id, :parse_id,
             :serialize_attribute, :deserialize_attribute,
             :sort_expression, :search_column, :parse_object_id,
             to: :repository

    def quoted_table_name
      table_name
    end

    def quote_column_name(name)
      name
    end

    def to_s
      model.to_s
    end

    def config
      Config.model self
    end

    def to_param
      @model_name.split('::').collect(&:underscore).join('~')
    end

    def param_key
      @model_name.split('::').collect(&:underscore).join('_')
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

    def initialize_active_record
      @adapter = :active_record
      require 'rails_admin/adapters/active_record'
      extend Adapters::ActiveRecord
      @repository = Adapters::ActiveRecord::Repository.new(self)
    end

    def initialize_mongoid
      @adapter = :mongoid
      require 'rails_admin/adapters/mongoid'
      extend Adapters::Mongoid
      @repository = Adapters::Mongoid::Repository.new(self)
    end
  end
end
