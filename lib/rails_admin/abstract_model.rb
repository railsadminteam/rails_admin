# frozen_string_literal: true

require 'rails_admin/adapters'
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
    attr_reader :adapter, :model_name, :reflection, :repository

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
      registration = Adapters.detect(model)
      return unless registration

      @adapter = registration.name
      @reflection = registration.reflection.new(self)
      @repository = registration.repository.new(self)
    end

    # do not store a reference to the model, does not play well with ActiveReload/Rails3.2
    def model
      @model_name.constantize
    end

    # What the model is, and what can be done with it, are the two halves of an
    # adapter. AbstractModel is the one object callers talk to; it owns neither
    # answer and forwards both.
    delegate :properties, :associations, :base_class, :primary_key, :table_name,
             :quoted_table_name, :quote_column_name, :encoding, :embedded?, :cyclic?,
             :adapter_supports_joins?, :belongs_to_required_by_default,
             :pretty_name, :human_attribute_name, :attribute_required?,
             :attribute_length_options, :attribute_enum_values, :dummy_record,
             to: :reflection

    delegate :new, :get, :first, :all, :count, :destroy, :scoped, :where,
             :each_associated_children, :format_id, :parse_id,
             :serialize_attribute, :deserialize_attribute,
             :sort_expression, :search_column, :parse_object_id,
             to: :repository

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

    def initialize_active_record
      @adapter = :active_record
      require 'rails_admin/adapters/active_record'
      @reflection = Adapters::ActiveRecord::Reflection.new(self)
      @repository = Adapters::ActiveRecord::Repository.new(self)
    end

    def initialize_mongoid
      @adapter = :mongoid
      require 'rails_admin/adapters/mongoid'
      @reflection = Adapters::Mongoid::Reflection.new(self)
      @repository = Adapters::Mongoid::Repository.new(self)
    end
  end
end
