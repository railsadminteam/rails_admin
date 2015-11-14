require 'rails_admin/support/i18n'

module RailsAdmin
  module Support
    class Datetime
      class << self
        include RailsAdmin::Support::I18n

        def delocalize(date_string, format)
          return date_string if ::I18n.locale.to_s == 'en'
          format.to_s.scan(/%[AaBbp]/) do |match|
            case match
            when '%A'
              english = ::I18n.t('date.day_names', locale: :en)
              day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
            when '%a'
              english = ::I18n.t('date.abbr_day_names', locale: :en)
              abbr_day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
            when '%B'
              english = ::I18n.t('date.month_names', locale: :en)[1..-1]
              month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
            when '%b'
              english = ::I18n.t('date.abbr_month_names', locale: :en)[1..-1]
              abbr_month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
            when '%p'
              date_string = date_string.gsub(/#{::I18n.t('date.time.am', default: "am")}/, 'am')
              date_string = date_string.gsub(/#{::I18n.t('date.time.pm', default: "pm")}/, 'pm')
            end
          end
          date_string
        end

        def normalize(date_string, format)
          return unless date_string
          delocalize(date_string, format)
          parse_date_string(date_string)
        end

        # Parse normalized date strings using time zone
        def parse_date_string(date_string)
          ::Time.zone.parse(date_string)
        end
      end

      attr_reader :strftime_format

      def initialize(strftime_format)
        @strftime_format = strftime_format
      end

      # Ruby to javascript formatting options translator
      def to_momentjs
        # Ruby format options as a key and momentjs format options
        # as a value
        translations = {
          '%a' => 'ddd',        # The abbreviated weekday name ("Sun")
          '%A' => 'dddd',       # The  full  weekday  name ("Sunday")
          '%b' => 'MMM',        # The abbreviated month name ("Jan")
          '%B' => 'MMMM',       # The  full  month  name ("January")
          '%d' => 'DD',         # Day of the month (01..31)
          '%D' => 'MM/DD/YY',   # American date format mm/dd/yy
          '%e' => 'D',          # Day of the month (1..31)
          '%F' => 'YY-MM-DD',   # ISO 8601 date format
          '%H' => 'HH',         # Hour of the day, 24-hour clock (00..23)
          '%I' => 'hh',         # Hour of the day, 12-hour clock (01..12)
          '%m' => 'MM',         # Month of the year (01..12)
          '%-m' => 'M',         # Month of the year (1..12)
          '%M' => 'mm',         # Minute of the hour (00..59)
          '%p' => 'A',          # Meridian indicator ('AM' or 'PM')
          '%S' => 'ss',         # Second of the minute (00..60)
          '%Y' => 'YYYY',       # Year with century
          '%y' => 'YY',         # Year without a century (00..99)
        }

        strftime_format.gsub(/\w[^.(!?%)\W]{1,}/, '[\0]').gsub(/%(\w|\-\w)/) { |match| translations[match] }
      end

      def parse_string(value)
        return if value.blank?
        return value if %w(DateTime Date Time).include?(value.class.name)

        delocalized_value = self.class.delocalize(value, strftime_format)
        return if delocalized_value.blank?

        begin
          Time.zone.local_to_utc(::DateTime.strptime(delocalized_value, strftime_format))
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
