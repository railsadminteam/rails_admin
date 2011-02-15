require 'rails_admin/config/fields/base'
require 'rails_admin/i18n_support'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 170
          @datepicker_options = {}
          @format = :long
          @i18n_scope = [:time, :formats]

          class << self

            include RailsAdmin::I18nSupport

            attr_reader :datepicker_options, :format, :i18n_scope

            def normalize(date_string, format)
              unless I18n.locale == "en"
                format.to_s.match(/%[AaBbp]/).each do |match|
                  case match
                  when '%A'
                    english = I18n.t('date.day_names', :locale => :en)
                    day_names.each_with_index {|d, i| date_string.gsub!(/#{d}/, english[i]) }
                  when '%a'
                    english = I18n.t('date.abbr_day_names', :locale => :en)
                    abbr_day_names.each_with_index {|d, i| date_string.gsub!(/#{d}/, english[i]) }
                  when '%B'
                    english = I18n.t('date.month_names', :locale => :en)
                    month_names.each_with_index {|m, i| date_string.gsub!(/#{m}/, english[i]) }
                  when '%b'
                    english = I18n.t('date.abbr_month_names', :locale => :en)
                    abbr_month_names.each_with_index {|m, i| date_string.gsub!(/#{m}/, english[i]) }
                  when '%p'
                    date_string.gsub!(/#{I18n.t('date.time.am', :default => "am")}/, "am")
                    date_string.gsub!(/#{I18n.t('date.time.pm', :default => "pm")}/, "pm")
                  end
                end
              end
              Date.parse(date_string, format)
            end

          end

          # Ruby to prototype datepicker formatting options translator
          def datepicker_date_format
            # Ruby format options as a key and jquery datepicker format options
            # as a value
            translations = {
              "%a" => "D",          # The abbreviated weekday name ("Sun")
              "%A" => "DD",         # The  full  weekday  name ("Sunday")
              "%b" => "M",          # The abbreviated month name ("Jan")
              "%B" => "MM",         # The  full  month  name ("January")
              "%d" => "dd",         # Day of the month (01..31)
              "%D" => "mm/dd/y",    # American date format mm/dd/yy
              "%e" => "d",          # Day of the month (1..31)
              "%F" => "yy-mm-dd",   # ISO 8601 date format
              "%H" => "??",         # Hour of the day, 24-hour clock (00..23)
              "%I" => "??",         # Hour of the day, 12-hour clock (01..12)
              "%m" => "mm",         # Month of the year (01..12)
              "%-m" => "m",         # Month of the year (1..12)
              "%M" => "??",         # Minute of the hour (00..59)
              "%p" => "??",         # Meridian indicator ("AM" or "PM")
              "%S" => "??",         # Second of the minute (00..60)
              "%Y" => "yy",         # Year with century
              "%y" => "y",          # Year without a century (00..99)
            }
            strftime_format.gsub(/%\w/) {|match| translations[match]}
          end

          def datepicker_options
            options = {
              "dateFormat" => datepicker_date_format,
              "dayNames" => self.class.day_names,
              "dayNamesShort" => self.class.abbr_day_names,
              "firstDay" => 1,
              "monthNames" => self.class.month_names,
              "monthNamesShort" => self.class.abbr_month_names,
            }

            options = options.merge self.class.datepicker_options

            ActiveSupport::JSON.encode(options).html_safe
          end

          register_instance_option(:date_format) do
            self.class.format
          end

          register_instance_option(:formatted_value) do
            unless (time = value).nil?
              I18n.l(time, :format => strftime_format)
            else
              "".html_safe
            end
          end

          register_instance_option(:parse_input) do |params|
            params[name] = self.class.normalize(params[name], strftime_format) if params[name]
          end

          register_instance_option(:partial) do
            "form_datetime"
          end

          register_instance_option(:strftime_format) do
            format = date_format.to_sym
            I18n.t(format, :scope => self.class.i18n_scope, :default => [
              I18n.t(format, :scope => self.class.i18n_scope, :locale => :en),
              I18n.t(self.class.format, :scope => self.class.i18n_scope, :locale => :en),
            ]).to_s
          end
        end
      end
    end
  end
end