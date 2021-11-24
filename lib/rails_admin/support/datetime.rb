module RailsAdmin
  module Support
    class Datetime
      # Ruby format options as a key and momentjs format options as a value
      MOMENTJS_TRANSLATIONS = {
        '%A' => 'dddd',       # The  full  weekday  name ("Sunday")
        '%a' => 'ddd',        # The abbreviated weekday name ("Sun")
        '%B' => 'MMMM',       # The  full  month  name ("January")
        '%b' => 'MMM',        # The abbreviated month name ("Jan")
        '%D' => 'MM/DD/YY',   # American date format mm/dd/yy
        '%d' => 'DD',         # Day of the month (01..31)
        '%-d' => 'D',         # Day of the month (1..31)
        '%F' => 'YYYY-MM-DD', # ISO 8601 date format
        '%G' => 'GGGG',       # ISO Week Year (2020)
        '%g' => 'GG',         # ISO Week Year (20)
        '%H' => 'HH',         # Hour of the day, 24-hour clock (00..23)
        '%-H' => 'H',         # Hour of the day, 24-hour clock (0..23)
        '%h' => 'MMM',        # Same as %b
        '%I' => 'hh',         # Hour of the day, 12-hour clock (01..12)
        '%-I' => 'h',         # Hour of the day, 12-hour clock (1..12)
        '%j' => 'DDDD',       # Day of Year (001..366)
        '%L' => 'SSS',        # Millisecond of the second (000..999)
        '%M' => 'mm',         # Minute of the hour (00..59)
        '%-M' => 'm',         # Minute of the hour (0..59)
        '%m' => 'MM',         # Month of the year (01..12)
        '%-m' => 'M',         # Month of the year (1..12)
        '%N' => 'SSSSSSSSS',  # Fractional seconds 9 digits
        '%9N' => 'SSSSSSSSS', # Fractional seconds 9 digits
        '%6N' => 'SSSSSS',    # Fractional seconds 6 digits
        '%3N' => 'SSS',       # Fractional seconds 3 digits
        '%P' => 'a',          # Meridian indicator ('am' or 'pm')
        '%p' => 'A',          # Meridian indicator ('AM' or 'PM')
        '%Q' => 'x',          # Number of milliseconds since 1970-01-01 00:00:00 UTC.
        '%R' => 'HH:mm',      # 24-hour time (%H:%M)
        '%r' => 'hh:mm:ss A', # 12-hour time (%I:%M:%S %p)
        '%S' => 'ss',         # Second of the minute (00..60)
        '%-S' => 's',         # Second of the minute (0..60)
        '%s' => 'X',          # Number of seconds since 1970-01-01 00:00:00 UTC.
        '%T' => 'HH:mm:ss',   # 24-hour time (%H:%M:%S)
        '%U' => 'ww',         # Week number of the year.  The week starts with Sunday.  (00..53)
        '%u' => 'E',          # Day of the week (Monday is 1, 1..7)
        '%W' => 'WW',         # Week number of the year.  The week starts with Monday.  (00..53)
        '%w' => 'e',          # Day of the week (Sunday is 0, 0..6)
        '%X' => 'HH:mm:ss',   # Same as %T
        '%x' => 'MM/DD/YY',   # Same as %D
        '%Y' => 'YYYY',       # Year with century
        '%y' => 'YY',         # Year without a century (00..99)
        '%Z' => 'Z',          # Equivalent to %:z (e.g. +09:00)
        '%z' => 'ZZ',         # Time zone as hour and minute offset from UTC (e.g. +0900)
        '%:z' => 'Z',         # Time zone as hour and minute offset from UTC with a colon (e.g. +09:00),
        '%%' => '%',
      }.freeze

      class << self
        def to_momentjs(strftime_format)
          strftime_format.gsub(/(?<!%)(?<![-0-9:])\w+/, '[\0]').gsub(/%([-0-9:]?\w)/) do |match|
            MOMENTJS_TRANSLATIONS[match] or raise <<-MSG.gsub(/^\s{14}/, '')
              Unsupported strftime directive '#{match}' was found. Please consider explicitly setting momentjs_format instance option for the field.
                field(:name_of_field) { momentjs_format '...' }
            MSG
          end
        end
      end
    end
  end
end
