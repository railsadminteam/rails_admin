

module RailsAdmin
  module Support
    class Datetime
      # Ruby format options as a key and flatpickr format options as a value
      FLATPICKR_TRANSLATIONS = {
        '%A' => 'l',       # The  full  weekday  name ("Sunday")
        '%a' => 'D',       # The abbreviated weekday name ("Sun")
        '%B' => 'F',       # The  full  month  name ("January")
        '%b' => 'M',       # The abbreviated month name ("Jan")
        '%D' => 'm/d/y',   # American date format mm/dd/yy
        '%d' => 'd',       # Day of the month (01..31)
        '%-d' => 'j',      # Day of the month (1..31)
        '%e' => 'j',       # Day of the month (1..31)
        '%F' => 'Y-m-d',   # ISO 8601 date format
        '%H' => 'H',       # Hour of the day, 24-hour clock (00..23)
        '%-H' => 'H',      # Hour of the day, 24-hour clock (0..23)
        '%h' => 'M',       # Same as %b
        '%I' => 'G',       # Hour of the day, 12-hour clock (01..12)
        '%-I' => 'h',      # Hour of the day, 12-hour clock (1..12)
        '%k' => 'H',       # Hour of the day, 24-hour clock (0..23)
        '%l' => 'h',       # Hour of the day, 12-hour clock (1..12)
        '%-l' => 'h',      # Hour of the day, 12-hour clock (1..12)
        '%M' => 'i',       # Minute of the hour (00..59)
        '%-M' => 'i',      # Minute of the hour (00..59)
        '%m' => 'm',       # Month of the year (01..12)
        '%-m' => 'n',      # Month of the year (1..12)
        '%P' => 'K',       # Meridian indicator ('am' or 'pm')
        '%p' => 'K',       # Meridian indicator ('AM' or 'PM')
        '%R' => 'H:i',     # 24-hour time (%H:%M)
        '%r' => 'G:i:S K', # 12-hour time (%I:%M:%S %p)
        '%S' => 'S',       # Second of the minute (00..60)
        '%-S' => 's',      # Second of the minute (0..60)
        '%s' => 'U',       # Number of seconds since 1970-01-01 00:00:00 UTC.
        '%T' => 'H:i:S',   # 24-hour time (%H:%M:%S)
        '%U' => 'W',       # Week number of the year.  The week starts with Sunday.  (00..53)
        '%w' => 'w',       # Day of the week (Sunday is 0, 0..6)
        '%X' => 'H:i:S',   # Same as %T
        '%x' => 'm/d/y',   # Same as %D
        '%Y' => 'Y',       # Year with century
        '%y' => 'y',       # Year without a century (00..99)
        '%%' => '%',
      }.freeze

      class << self
        def to_flatpickr_format(strftime_format)
          strftime_format.gsub(/(?<!%)(?<![-0-9:])\w/, '\\\\\0').gsub(/%([-0-9:]?\w)/) do |match|
            # Timezone can't be handled by frontend, the server's one is always used
            case match
            when '%Z', '%:z' # Time zone as hour and minute offset from UTC with a colon (e.g. +09:00)
              Time.zone.formatted_offset
            when '%z' # Time zone as hour and minute offset from UTC (e.g. +0900)
              Time.zone.formatted_offset(false)
            else
              FLATPICKR_TRANSLATIONS[match] or raise <<~MSG
                Unsupported strftime directive '#{match}' was found. Please consider explicitly setting flatpickr_format instance option for the field.
                  field(:name_of_field) { flatpickr_format '...' }
              MSG
            end
          end
        end
      end
    end
  end
end
