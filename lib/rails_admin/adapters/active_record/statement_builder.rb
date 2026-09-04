# frozen_string_literal: true

require 'rails_admin/adapters/statement_builder'

module RailsAdmin
  module Adapters
    module ActiveRecord
      class StatementBuilder < RailsAdmin::Adapters::StatementBuilder
        def initialize(column, type, value, operator, adapter_name)
          super column, type, value, operator
          @adapter_name = adapter_name
        end

      protected

        def unary_operators
          case @type
          when :boolean
            boolean_unary_operators
          when :uuid
            uuid_unary_operators
          when :integer, :decimal, :float
            numeric_unary_operators
          else
            generic_unary_operators
          end
        end

      private

        def generic_unary_operators
          {
            '_blank' => ["(#{@column} IS NULL OR #{@column} = '')"],
            '_present' => ["(#{@column} IS NOT NULL AND #{@column} != '')"],
            '_null' => ["(#{@column} IS NULL)"],
            '_not_null' => ["(#{@column} IS NOT NULL)"],
            '_empty' => ["(#{@column} = '')"],
            '_not_empty' => ["(#{@column} != '')"],
          }
        end

        def boolean_unary_operators
          generic_unary_operators.merge(
            '_blank' => ["(#{@column} IS NULL)"],
            '_empty' => ["(#{@column} IS NULL)"],
            '_present' => ["(#{@column} IS NOT NULL)"],
            '_not_empty' => ["(#{@column} IS NOT NULL)"],
          )
        end
        alias_method :numeric_unary_operators, :boolean_unary_operators
        alias_method :uuid_unary_operators, :boolean_unary_operators

        def range_filter(min, max)
          if min && max && min == max
            ["(#{@column} = ?)", min]
          elsif min && max
            ["(#{@column} BETWEEN ? AND ?)", min, max]
          elsif min
            ["(#{@column} >= ?)", min]
          elsif max
            ["(#{@column} <= ?)", max]
          end
        end

        def build_statement_for_type
          case @type
          when :boolean                   then build_statement_for_boolean
          when :integer, :decimal, :float then build_statement_for_integer_decimal_or_float
          when :string, :text, :citext    then build_statement_for_string_or_text
          when :enum                      then build_statement_for_enum
          when :belongs_to_association    then build_statement_for_belongs_to_association
          when :uuid                      then build_statement_for_uuid
          end
        end

        def build_statement_for_boolean
          case @value
          when 'false', 'f', '0'
            ["(#{@column} IS NULL OR #{@column} = ?)", false]
          when 'true', 't', '1'
            ["(#{@column} = ?)", true]
          end
        end

        def column_for_value(value)
          ["(#{@column} = ?)", value]
        end

        def build_statement_for_belongs_to_association
          return if @value.blank?

          ["(#{@column} = ?)", @value.to_i] if @value.to_i.to_s == @value
        end

        def build_statement_for_string_or_text
          return if @value.blank?

          return ["(#{@column} = ?)", @value] if ['is', '='].include?(@operator)

          @value = @value.mb_chars.downcase unless %w[postgresql postgis].include? ar_adapter

          @value =
            case @operator
            when 'default', 'like', 'not_like'
              "%#{@value}%"
            when 'starts_with'
              "#{@value}%"
            when 'ends_with'
              "%#{@value}"
            else
              return
            end

          if %w[postgresql postgis].include? ar_adapter
            if @operator == 'not_like'
              ["(#{@column} NOT ILIKE ?)", @value]
            else
              ["(#{@column} ILIKE ?)", @value]
            end
          elsif @operator == 'not_like'
            ["(LOWER(#{@column}) NOT LIKE ?)", @value]
          else
            ["(LOWER(#{@column}) LIKE ?)", @value]
          end
        end

        def build_statement_for_enum
          return if @value.blank?

          ["(#{@column} IN (?))", Array.wrap(@value)]
        end

        def build_statement_for_uuid
          column_for_value(@value) if /\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/.match?(@value.to_s)
        end

        def ar_adapter
          @adapter_name.downcase
        end
      end
    end
  end
end
