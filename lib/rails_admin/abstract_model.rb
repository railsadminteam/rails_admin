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
    attr_reader :adapter, :model_name

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

    def quoted_table_name
      table_name
    end

    def quote_column_name(name)
      name
    end

    # Render a sort target as an expression the store understands. Adapters that
    # need qualification or quoting override this; anything already expressed in
    # the store's own terms is handed through.
    def sort_expression(order)
      order.to_s
    end

    # Render a search target as the column reference the store understands.
    # Overridden where reaching an associated attribute takes more than the
    # dotted path itself.
    def search_column(target)
      target.to_s
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

    def where(conditions)
      model.where(conditions)
    end

    def each_associated_children(object)
      associations.each do |association|
        case association.type
        when :has_one
          child = object.send(association.name)
          yield(association, [child]) if child
        when :has_many
          children = object.send(association.name)
          yield(association, Array.new(children))
        end
      end
    end

    def format_id(id)
      id
    end

    def parse_id(id)
      id
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

    # Convert a Ruby value into the representation the store holds for the given
    # attribute, and back.
    #
    # Both default to passing the value through. Adapters override them when
    # their ORM has a type system able to do better; the Mongoid adapter does
    # not, so values reach it unconverted.
    def serialize_attribute(_name, value)
      value
    end

    def deserialize_attribute(_name, value)
      value
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
    end

    def initialize_mongoid
      @adapter = :mongoid
      require 'rails_admin/adapters/mongoid'
      extend Adapters::Mongoid
    end

    def parse_field_value(field, value)
      value.is_a?(Array) ? value.map { |v| field.parse_value(v) } : field.parse_value(value)
    end

    # The search box asks every queryable field about the same term. Yields
    # [field, parsed value, operator] so that each adapter is left with turning a
    # condition into a scope and combining them, rather than reimplementing which
    # fields take part and how their values are parsed.
    def each_query_condition(query, fields)
      return to_enum(:each_query_condition, query, fields) unless block_given?

      fields.each do |field|
        yield field, parse_field_value(field, query), field.search_operator
      end
    end

    # Each filter as [field, parsed value, operator].
    #
    # Filters naming a field that does not exist are skipped, and a filter
    # arriving without an operator falls back to the configured default -- the
    # field types that offer no operator in the filter UI submit none.
    #
    # filters looks like {"string_field" => {"0055" => {"o" => "like", "v" => "x"}}}
    # where "0055" is the filter index and has no meaning here.
    def each_filter_condition(filters, fields)
      return to_enum(:each_filter_condition, filters, fields) unless block_given?

      filters.each_pair do |field_name, filters_dump|
        field = fields.detect { |f| f.name.to_s == field_name }
        next unless field

        filters_dump.each_value do |filter_dump|
          yield field, parse_field_value(field, filter_dump[:v]), (filter_dump[:o] || RailsAdmin::Config.default_search_operator)
        end
      end
    end
  end
end
