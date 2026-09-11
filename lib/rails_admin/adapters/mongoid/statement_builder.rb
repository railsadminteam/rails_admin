# frozen_string_literal: true

require 'rails_admin/adapters/statement_builder'

module RailsAdmin
  module Adapters
    module Mongoid
      class StatementBuilder < RailsAdmin::Adapters::StatementBuilder
      protected

        def unary_operators
          {
            '_blank' => {@column => {'$in' => [nil, '']}},
            '_present' => {@column => {'$nin' => [nil, '']}},
            '_null' => {@column => nil},
            '_not_null' => {@column => {'$ne' => nil}},
            '_empty' => {@column => ''},
            '_not_empty' => {@column => {'$ne' => ''}},
          }
        end

      private

        def build_statement_for_type
          case @type
          when :boolean                   then build_statement_for_boolean
          when :integer, :decimal, :float then build_statement_for_integer_decimal_or_float
          when :string, :text             then build_statement_for_string_or_text
          when :enum                      then build_statement_for_enum
          when :belongs_to_association, :bson_object_id then build_statement_for_belongs_to_association_or_bson_object_id
          end
        end

        def build_statement_for_boolean
          case @value
          when 'false', 'f', '0'
            {@column => false}
          when 'true', 't', '1'
            {@column => true}
          end
        end

        def column_for_value(value)
          {@column => value}
        end

        def build_statement_for_string_or_text
          return if @value.blank?

          @value =
            case @operator
            when 'not_like'
              Regexp.compile("^((?!#{Regexp.escape(@value)}).)*$", Regexp::IGNORECASE)
            when 'default', 'like'
              Regexp.compile(Regexp.escape(@value), Regexp::IGNORECASE)
            when 'starts_with'
              Regexp.compile("^#{Regexp.escape(@value)}", Regexp::IGNORECASE)
            when 'ends_with'
              Regexp.compile("#{Regexp.escape(@value)}$", Regexp::IGNORECASE)
            when 'is', '='
              @value.to_s
            else
              return
            end

          {@column => @value}
        end

        def build_statement_for_enum
          return if @value.blank?

          {@column => {'$in' => Array.wrap(@value)}}
        end

        def build_statement_for_belongs_to_association_or_bson_object_id
          {@column => @value} if @value
        end

        def range_filter(min, max)
          if min && max && min == max
            {@column => min}
          elsif min && max
            {@column => {'$gte' => min, '$lte' => max}}
          elsif min
            {@column => {'$gte' => min}}
          elsif max
            {@column => {'$lte' => max}}
          end
        end
      end
    end
  end
end
