module RailsAdmin
  module Support
    class Datetime
      # Ruby format options as a key and momentjs format options as a value
      MOMENTJS_TRANSLATIONS = {
        '%a' => 'ddd',        # The abbreviated weekday name ("Sun")
        '%A' => 'dddd',       # The  full  weekday  name ("Sunday")
        '%b' => 'MMM',        # The abbreviated month name ("Jan")
        '%B' => 'MMMM',       # The  full  month  name ("January")
        '%d' => 'DD',         # Day of the month (01..31)
        '%-d' => 'D',         # Day of the month (1..31)
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
      }.freeze

      class << self
        def to_momentjs(strftime_format)
          strftime_format.gsub(/\w[^.(!?%)\W]{1,}/, '[\0]').gsub(/%(\w|\-\w)/) do |match|
            MOMENTJS_TRANSLATIONS[match]
          end
        end
      end
    end
  end
end
