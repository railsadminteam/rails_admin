# frozen_string_literal: true

module RailsAdmin
  module Criteria
    # Resolves the period a date filter asks for into the two dates bounding it,
    # so that what reaches a store is always absolute. Relative operators such as
    # 'today' or 'this_week' are the config layer's vocabulary; no adapter needs
    # to know them.
    #
    # Everything is read in the application time zone. Reading part of it from
    # the system clock instead would let 'today' and 'yesterday' land on dates
    # that are not a day apart whenever the two disagree.
    class Period
      def initialize(operator, value)
        @operator = operator
        @value = value
      end

      # [from, to], either of which may be nil for an open-ended period.
      def bounds
        case @operator
        when 'between'   then between
        when 'today'     then today
        when 'yesterday' then yesterday
        when 'this_week' then this_week
        when 'last_week' then last_week
        else default
        end
      end

    private

      def today
        [Date.current, Date.current]
      end

      def yesterday
        [Date.current.yesterday, Date.current.yesterday]
      end

      def this_week
        [Date.current.beginning_of_week, Date.current.end_of_week]
      end

      def last_week
        last_week_day = Date.current - 1.week
        [last_week_day.beginning_of_week, last_week_day.end_of_week]
      end

      def between
        [@value[1], @value[2]]
      end

      def default
        [default_date, default_date]
      end

      def default_date
        Array.wrap(@value).first
      end
    end
  end
end
