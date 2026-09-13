# frozen_string_literal: true

require 'rails_admin/adapters/repository'

module RailsAdmin
  module Adapters
    module ActiveRecord
      class Repository < RailsAdmin::Adapters::Repository
        BATCH_SIZE = 1000

        def new(params = {})
          model.new(params)
        end

        def get(id, scope = scoped)
          primary_key_scope(scope, id).first
        end

        def scoped
          model.all
        end

        def first(options = {}, scope = nil)
          all(options, scope).first
        end

        def all(options = {}, scope = nil)
          scope ||= scoped
          scope = scope.includes(options[:include]) if options[:include]
          scope = scope.limit(options[:limit]) if options[:limit]
          scope = bulk_scope(scope, options) if options[:bulk_ids]
          scope = query_scope(scope, options[:query]) if options[:query]
          scope = filter_scope(scope, options[:filters]) if options[:filters]
          scope = scope.send(Kaminari.config.page_method_name, options[:page]).per(options[:per]) if options[:page] && options[:per]
          scope = sort_scope(scope, options) if options[:sort]
          scope
        end

        def count(options = {}, scope = nil)
          all(options.merge(limit: false, page: false), scope).count(:all)
        end

        def destroy(objects)
          Array.wrap(objects).each(&:destroy)
        end

        # A relation loads whole when it is iterated, so the records are fetched
        # in batches. find_each does that, but only in primary key order, which is
        # why an export used to come out in a different order from the list.
        #
        # A sort by the primary key alone still goes to find_each, which walks the
        # key and so stays fast however far in it gets. Any other sort is fetched
        # a page at a time by offset, with the primary key added as a tie-break:
        # rows that sort equal are otherwise free to come back in a different
        # order for each page, and stitching the pages together could repeat one
        # row and lose another.
        def each_record(scope, &block)
          return to_enum(:each_record, scope) unless block
          return super unless scope.is_a?(::ActiveRecord::Relation)
          # Already cut down to size, and batching would replace the limit.
          return scope.each(&block) if scope.limit_value || scope.offset_value
          return scope.find_each(batch_size: BATCH_SIZE, &block) if scope.order_values.empty?

          # find_each in the composite_primary_keys gem does not keep a descending
          # order across a composite key. Only reachable below Rails 7.1, so this
          # goes with support for Rails 7.0, as the gem does.
          direction = primary_key_order(scope) unless primary_keys.many? && defined?(::CompositePrimaryKeys)
          if direction
            scope.reorder(nil).find_each(batch_size: BATCH_SIZE, order: direction, &block)
          else
            each_record_by_offset(scope, &block)
          end
        end

        def read(record, name)
          record.has_attribute?(name) ? record.read_attribute(name) : record.send(name)
        end

        def format_id(id)
          return id unless primary_keys.many?

          RailsAdmin.config.composite_keys_serializer.serialize(id)
        end

        def parse_id(id)
          return id unless primary_keys.many?

          ids = RailsAdmin.config.composite_keys_serializer.deserialize(id)
          primary_keys.each_with_index do |key, i|
            ids[i] = model.type_for_attribute(key).cast(ids[i])
          end
          ids
        end

        def serialize_attribute(name, value)
          model.type_for_attribute(name.to_s).serialize(value)
        end

        def deserialize_attribute(name, value)
          model.type_for_attribute(name.to_s).deserialize(value)
        end

        def sort_expression(order)
          return order.to_s unless order.is_a?(RailsAdmin::Criteria::Path)

          "#{quoted_path_table_name(order)}.#{quote_column_name(order.attribute)}"
        end

        # Unlike sorting, search statements are assembled unquoted, and the table
        # half is read back out to build the relation's references.
        def search_column(target)
          return target.to_s unless target.is_a?(RailsAdmin::Criteria::Path)

          "#{path_table_name(target)}.#{target.attribute}"
        end

      private

        # The model the path's attribute lives on. Only a single association hop
        # is resolvable, which is all the field configuration can express.
        def path_abstract_model(path)
          return abstract_model if path.root?

          association = associations.detect { |a| a.name == path.associations.first }
          raise ArgumentError.new("Unknown association in path: #{path}") unless association

          RailsAdmin::AbstractModel.new(association.klass)
        end

        def path_table_name(path)
          path_abstract_model(path).table_name
        end

        def quoted_path_table_name(path)
          path_abstract_model(path).quoted_table_name
        end

        def primary_key_scope(scope, id)
          scope.where(primary_keys.zip(Array(parse_id(id))).to_h)
        end

        # The direction a scope is sorted in when it is sorted by the primary key
        # and nothing else, or nil. Rather than reading the order back out of the
        # SQL, each way #all could have sorted by the key is rebuilt through
        # #sort_scope and compared, so what is recognised is exactly what #all
        # produces.
        def primary_key_order(scope)
          sorts = [primary_key]
          sorts << RailsAdmin::Criteria::Path[primary_keys.first] unless primary_keys.many?
          %i[desc asc].detect do |direction|
            sorts.any? do |sort|
              sort_scope(scope, sort: sort, sort_reverse: direction == :asc).order_values == scope.order_values
            end
          end
        end

        def each_record_by_offset(scope, &block)
          scope = scope.order(*primary_keys.collect { |key| Arel.sql("#{quoted_table_name}.#{quote_column_name(key)}") })
          (0..).step(BATCH_SIZE) do |offset|
            batch = scope.limit(BATCH_SIZE).offset(offset).to_a
            batch.each(&block)
            break if batch.size < BATCH_SIZE
          end
        end

        # A composite key has to be matched one whole key at a time, which costs
        # an OR per id; a single-column key gets the IN it deserves.
        def bulk_scope(scope, options)
          if primary_keys.many?
            options[:bulk_ids].map { |id| primary_key_scope(scope, id) }.reduce(&:or)
          else
            scope.where(primary_keys.first => options[:bulk_ids])
          end
        end

        def sort_scope(scope, options)
          direction = options[:sort_reverse] ? :asc : :desc
          case options[:sort]
          when RailsAdmin::Criteria::Path, String, Symbol
            scope.reorder("#{sort_expression(options[:sort])} #{direction}")
          when Array
            scope.reorder(options[:sort].zip(Array.new(options[:sort].size) { direction }).to_h)
          when Hash
            scope.reorder(options[:sort].map { |table_name, column| "#{table_name}.#{column}" }.
              zip(Array.new(options[:sort].size) { direction }).to_h)
          else
            raise ArgumentError.new("Unsupported sort value: #{options[:sort]}")
          end
        end

        def query_scope(scope, query, fields = config.list.fields.select(&:queryable?))
          return scope.send(config.list.search_by, query) if config.list.search_by

          wb = WhereBuilder.new(scope, self)
          # OR all query statements
          each_query_condition(query, fields) { |field, value, operator| wb.add(field, value, operator) }
          wb.build
        end

        def filter_scope(scope, filters, fields = config.list.fields.select(&:filterable?))
          each_filter_condition(filters, fields) do |field, value, operator|
            wb = WhereBuilder.new(scope, self)
            wb.add(field, value, operator)
            # AND current filter statements to other filter statements
            scope = wb.build
          end
          scope
        end

        def build_statement(column, type, value, operator)
          StatementBuilder.new(column, type, value, operator, model.connection.adapter_name).to_statement
        end
      end
    end
  end
end
