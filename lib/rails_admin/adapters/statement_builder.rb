# frozen_string_literal: true

require 'rails_admin/criteria/period'

module RailsAdmin
  module Adapters
    # Turns one search or filter condition into whatever the store's query
    # language calls a condition.
    #
    # The parts that are the same everywhere -- discarding a condition, unary
    # operators, numeric parsing, resolving a relative date into a range -- live
    # here; each adapter subclasses this and supplies the rest.
    class StatementBuilder
      def initialize(column, type, value, operator)
        @column = column
        @type = type
        @value = value
        @operator = operator
      end

      def to_statement
        return if [@operator, @value].any? { |v| v == '_discard' }

        unary_operators[@operator] || unary_operators[@value] ||
          build_statement_for_type_generic
      end

    protected

      def filtering_duration
        RailsAdmin::Criteria::Period.new(@operator, @value).bounds
      end

      def build_statement_for_type_generic
        build_statement_for_type || begin
          case @type
          when :date
            build_statement_for_date
          when :datetime, :timestamp, :time
            build_statement_for_datetime_or_timestamp
          end
        end
      end

      def build_statement_for_type
        raise 'You must override build_statement_for_type in your StatementBuilder'
      end

      def build_statement_for_integer_decimal_or_float
        case @value
        when Array
          val, range_begin, range_end = *@value.collect do |v|
            next unless v.to_i.to_s == v || v.to_f.to_s == v

            @type == :integer ? v.to_i : v.to_f
          end
          case @operator
          when 'between'
            range_filter(range_begin, range_end)
          else
            column_for_value(val) if val
          end
        else
          if @value.to_i.to_s == @value || @value.to_f.to_s == @value
            @type == :integer ? column_for_value(@value.to_i) : column_for_value(@value.to_f)
          end
        end
      end

      def build_statement_for_date
        start_date, end_date = filtering_duration
        if start_date
          start_date = begin
            start_date.to_date
          rescue StandardError
            nil
          end
        end
        if end_date
          end_date = begin
            end_date.to_date
          rescue StandardError
            nil
          end
        end
        range_filter(start_date, end_date)
      end

      def build_statement_for_datetime_or_timestamp
        start_date, end_date = filtering_duration
        start_date = start_date.beginning_of_day if start_date.is_a?(Date)
        end_date = end_date.end_of_day if end_date.is_a?(Date)
        range_filter(start_date, end_date)
      end

      def unary_operators
        raise 'You must override unary_operators in your StatementBuilder'
      end

      def range_filter(_min, _max)
        raise 'You must override range_filter in your StatementBuilder'
      end
    end
  end
end
