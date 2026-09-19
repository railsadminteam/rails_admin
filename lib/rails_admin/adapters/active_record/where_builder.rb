# frozen_string_literal: true

module RailsAdmin
  module Adapters
    module ActiveRecord
      # Collects the conditions a search or a filter produced into one relation.
      #
      # Statements are OR-ed together and the tables their columns belong to are
      # collected, so that the relation can be told to reference them and the
      # joins actually happen.
      class WhereBuilder
        def initialize(scope, repository)
          @statements = []
          @values = []
          @tables = []
          @scope = scope
          @repository = repository
        end

        def add(field, value, operator)
          field.searchable_columns.flatten.each do |column_infos|
            column = @repository.search_column(column_infos[:column])
            statement, value1, value2 = StatementBuilder.new(column, column_infos[:type], value, operator, @scope.connection.adapter_name).to_statement
            @statements << statement if statement.present?
            @values << value1 unless value1.nil?
            @values << value2 unless value2.nil?
            table, qualified = column.split('.')
            @tables.push(table) if qualified
          end
        end

        def build
          scope = @scope.where(@statements.join(' OR '), *@values)
          scope = scope.references(*@tables.uniq) if @tables.any?
          scope
        end
      end
    end
  end
end
