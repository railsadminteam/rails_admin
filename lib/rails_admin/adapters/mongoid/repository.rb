# frozen_string_literal: true

require 'rails_admin/adapters/repository'
require 'rails_admin/adapters/mongoid/bson'
require 'rails_admin/adapters/mongoid/object_extension'

module RailsAdmin
  module Adapters
    module Mongoid
      class Repository < RailsAdmin::Adapters::Repository
        def parse_object_id(value)
          Bson.parse_object_id(value)
        end

        def new(params = {})
          model.new(params).extend(ObjectExtension)
        end

        def get(id, scope = scoped)
          object = scope.find(id)
          return nil unless object

          object.extend(ObjectExtension)
        rescue StandardError => e
          raise e if %w[
            Mongoid::Errors::DocumentNotFound
            Mongoid::Errors::InvalidFind
            Moped::Errors::InvalidObjectId
            BSON::InvalidObjectId
            BSON::Error::InvalidObjectId
          ].exclude?(e.class.to_s)
        end

        def scoped
          model.scoped
        end

        def first(options = {}, scope = nil)
          all(options, scope).first
        end

        def all(options = {}, scope = nil)
          scope ||= scoped
          scope = scope.includes(*options[:include]) if options[:include]
          scope = scope.limit(options[:limit]) if options[:limit]
          scope = scope.any_in(_id: options[:bulk_ids]) if options[:bulk_ids]
          scope = query_scope(scope, options[:query]) if options[:query]
          scope = filter_scope(scope, options[:filters]) if options[:filters]
          scope = scope.send(Kaminari.config.page_method_name, options[:page]).per(options[:per]) if options[:page] && options[:per]
          scope = sort_by(options, scope) if options[:sort]
          scope
        rescue NoMethodError => e
          if /page/.match?(e.message)
            e = e.exception <<~ERROR
              #{e.message}
              If you don't have kaminari-mongoid installed, add `gem 'kaminari-mongoid'` to your Gemfile.
            ERROR
          end
          raise e
        end

        def count(options = {}, scope = nil)
          all(options.merge(limit: false, page: false), scope).count
        end

        def destroy(objects)
          Array.wrap(objects).each(&:destroy)
        end

      private

        def build_statement(column, type, value, operator)
          StatementBuilder.new(column, type, value, operator).to_statement
        end

        def make_field_conditions(field, value, operator)
          conditions_per_collection = {}
          field.searchable_columns.each do |column_infos|
            collection_name, column_name = parse_collection_name(column_infos[:column])
            statement = build_statement(column_name, column_infos[:type], value, operator)
            next unless statement

            conditions_per_collection[collection_name] ||= []
            conditions_per_collection[collection_name] << statement
          end
          conditions_per_collection
        end

        def query_scope(scope, query, fields = config.list.fields.select(&:queryable?))
          return scope.send(config.list.search_by, query) if config.list.search_by

          statements = []
          each_query_condition(query, fields) do |field, value, operator|
            statements.concat make_condition_for_current_collection(field, make_field_conditions(field, value, operator))
          end

          scope.where(statements.any? ? {'$or' => statements} : {})
        end

        def filter_scope(scope, filters, fields = config.list.fields.select(&:filterable?))
          statements = []

          each_filter_condition(filters, fields) do |field, value, operator|
            field_statements = make_condition_for_current_collection(field, make_field_conditions(field, value, operator))
            if field_statements.many?
              statements << {'$or' => field_statements}
            elsif field_statements.any?
              statements << field_statements.first
            end
          end

          scope.where(statements.any? ? {'$and' => statements} : {})
        end

        # Without joins an attribute on an associated document cannot be sorted
        # on. For a belongs_to the local foreign key is the closest thing
        # available, and is what the field configuration used to ask for on its
        # own once it had checked whether the adapter supported joins.
        def sort_field_name(path)
          return path.attribute.to_s if path.root?

          association = associations.detect { |a| a.name == path.associations.first }
          foreign_key = association.foreign_key if association&.type == :belongs_to
          raise 'sorting by associated model column is not supported in Non-Relational databases' unless foreign_key

          foreign_key.to_s
        end

        # Where a search target lives, as [collection, field] -- the collection is
        # only used to group conditions and to tell apart what can be asked of
        # this collection directly from what needs a second lookup.
        def parse_collection_name(target)
          return parse_collection_name_from_string(target.to_s) unless target.is_a?(RailsAdmin::Criteria::Path)

          return [table_name, target.attribute.to_s] if target.root?

          association = associations.detect { |a| a.name == target.associations.first }
          if association.try(:embeds?)
            # Embedded documents are reached by their field path, not by collection.
            [table_name, target.to_s]
          elsif association
            [RailsAdmin::AbstractModel.new(association.klass).table_name, target.attribute.to_s]
          else
            [target.associations.first.to_s, target.attribute.to_s]
          end
        end

        def parse_collection_name_from_string(column)
          collection_name, column_name = column.split('.')
          if associations.detect { |a| a.name == collection_name.to_sym }.try(:embeds?)
            [table_name, column]
          else
            [collection_name, column_name]
          end
        end

        def make_condition_for_current_collection(target_field, conditions_per_collection)
          result = []
          conditions_per_collection.each do |collection_name, conditions|
            if collection_name == table_name
              # conditions referring current model column are passed directly
              result.concat conditions
            else
              # otherwise, collect ids of documents that satisfy search condition
              result.concat perform_search_on_associated_collection(target_field.name, conditions)
            end
          end
          result
        end

        def perform_search_on_associated_collection(field_name, conditions)
          target_association = associations.detect { |a| a.name == field_name }
          return [] unless target_association

          model = target_association.klass
          case target_association.type
          when :belongs_to, :has_and_belongs_to_many
            [{target_association.foreign_key.to_s => {'$in' => model.where('$or' => conditions).all.collect { |r| r.send(target_association.primary_key) }}}]
          when :has_many, :has_one
            [{target_association.primary_key.to_s => {'$in' => model.where('$or' => conditions).all.collect { |r| r.send(target_association.foreign_key) }}}]
          end
        end

        def sort_by(options, scope)
          return scope unless options[:sort]

          case options[:sort]
          when RailsAdmin::Criteria::Path
            field_name = sort_field_name(options[:sort])
          when String
            field_name, collection_name = options[:sort].split('.').reverse
            raise 'sorting by associated model column is not supported in Non-Relational databases' if collection_name && collection_name != table_name
          when Symbol
            field_name = options[:sort].to_s
          end
          if options[:sort_reverse]
            scope.asc field_name
          else
            scope.desc field_name
          end
        end
      end
    end
  end
end
