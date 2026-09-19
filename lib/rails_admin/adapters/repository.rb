# frozen_string_literal: true

module RailsAdmin
  module Adapters
    # The half of an adapter that reaches the store: reading records, writing
    # them, and compiling what the configuration asked for into a query.
    #
    # One instance per model, held by the AbstractModel that composes it. Where a
    # repository needs to know something about the model rather than do something
    # with it, it asks through that facade, so that the two halves of an adapter
    # never have to reach for each other directly.
    class Repository
      attr_reader :abstract_model

      def initialize(abstract_model)
        @abstract_model = abstract_model
      end

      delegate :model, :config, :associations, :primary_key, :primary_keys, :table_name,
               :quoted_table_name, :quote_column_name, to: :abstract_model

      # Yield the records of a scope one at a time, in the order it is sorted in,
      # without holding all of them at once. What an export walks.
      #
      # Anything that is not a scope, such as an array of records, is taken as it
      # comes. A store whose query already streams in order needs nothing more
      # than #each, which is all this does.
      def each_record(scope, &block)
        return to_enum(:each_record, scope) unless block

        scope.each(&block)
      end

      # Read one attribute from a record: the value the store holds, rather than
      # what a reader of the same name would return.
      #
      # It began as a way around a column named +format+, which on Rails 3
      # reached Kernel#format when it was sent, because attribute methods were
      # not defined until method_missing had been hit (955cca09, 2011). Rails
      # defines them earlier now and that particular collision is gone, but the
      # rule it left behind is what a model redefining a reader still meets.
      #
      # Adapters say how their store tells an attribute from a method.
      def read(record, name)
        record.send(name)
      end

      # Persist a record, and whatever else the store needs doing to call it
      # saved. Answers the way the record's own #save does.
      def save(record)
        record.save
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

      # How a record's id travels through a URL, and back.
      #
      # Only composite keys need more than the id itself, so the default is to
      # hand it over unchanged.
      def format_id(id)
        id
      end

      def parse_id(id)
        id
      end

      # Convert a Ruby value into the representation the store holds for the
      # given attribute, and back.
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

      # Render a sort target as an expression the store understands. Adapters
      # that need qualification or quoting override this; anything already
      # expressed in the store's own terms is handed through.
      def sort_expression(order)
        order.to_s
      end

      # Render a search target as the column reference the store understands.
      # Overridden where reaching an associated attribute takes more than the
      # dotted path itself.
      def search_column(target)
        target.to_s
      end

    private

      def parse_field_value(field, value)
        value.is_a?(Array) ? value.map { |v| parse_one_value(field, v) } : parse_one_value(field, value)
      end

      # What reaches here came from the query string, so a field is regularly
      # handed something it cannot make sense of -- a date out of range, YAML
      # which does not parse. A field which cannot read the term takes no part in
      # the condition, rather than taking the whole page down with it.
      def parse_one_value(field, value)
        field.parse_value(value)
      rescue StandardError
        nil
      end

      # The search box asks every queryable field about the same term. Yields
      # [field, parsed value, operator] so that each adapter is left with turning
      # a condition into a scope and combining them, rather than reimplementing
      # which fields take part and how their values are parsed.
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
      #
      # Nothing guarantees that shape: the filters are read straight off the
      # query string, which anyone can write by hand. Anything which is not the
      # nesting the filter UI submits is ignored, so that a hand-written URL
      # leaves the list unfiltered rather than raising.
      def each_filter_condition(filters, fields)
        return to_enum(:each_filter_condition, filters, fields) unless block_given?
        return unless filters.respond_to?(:each_pair)

        filters.each_pair do |field_name, filters_dump|
          field = fields.detect { |f| f.name.to_s == field_name }
          next unless field && filters_dump.respond_to?(:each_value)

          filters_dump.each_value do |filter_dump|
            next unless filter_dump.respond_to?(:each_pair)

            yield field, parse_field_value(field, filter_dump[:v]), (filter_dump[:o] || RailsAdmin::Config.default_search_operator)
          end
        end
      end
    end
  end
end
