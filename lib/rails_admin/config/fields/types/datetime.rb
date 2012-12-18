require 'rails_admin/config/fields/base'
require 'rails_admin/i18n_support'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @format = :long
          @i18n_scope = [:time, :formats]
          @js_plugin_options = {}

          class << self

            include RailsAdmin::I18nSupport

            attr_reader :format, :i18n_scope, :js_plugin_options

            def normalize(date_string, format)
              unless I18n.locale == "en"
                format.to_s.scan(/%[AaBbp]/) do |match|
                  case match
                  when '%A'
                    english = I18n.t('date.day_names', :locale => :en)
                    day_names.each_with_index {|d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
                  when '%a'
                    english = I18n.t('date.abbr_day_names', :locale => :en)
                    abbr_day_names.each_with_index {|d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
                  when '%B'
                    english = I18n.t('date.month_names', :locale => :en)[1..-1]
                    month_names.each_with_index {|m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
                  when '%b'
                    english = I18n.t('date.abbr_month_names', :locale => :en)[1..-1]
                    abbr_month_names.each_with_index {|m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
                  when '%p'
                    date_string = date_string.gsub(/#{I18n.t('date.time.am', :default => "am")}/, "am")
                    date_string = date_string.gsub(/#{I18n.t('date.time.pm', :default => "pm")}/, "pm")
                  end
                end
              end
              parse_date_string(date_string)
            end

            # Parse normalized date strings using time zone
            def parse_date_string(date_string)
              ::Time.zone.parse(date_string)
            end

          end

          def formatted_date_value
            value = bindings[:object].new_record? && self.value.nil? && !self.default_value.nil? ? self.default_value : self.value
            value.nil? ? "" : I18n.l(value, :format => localized_date_format).strip
          end

          def formatted_time_value
            value.nil? ? "" : I18n.l(value, :format => localized_time_format)
          end

          # Ruby to javascript formatting options translator
          def js_date_format
            # Ruby format options as a key and javascript format options
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
              # "%H" => "??",         # Hour of the day, 24-hour clock (00..23)
              # "%I" => "??",         # Hour of the day, 12-hour clock (01..12)
              "%m" => "mm",         # Month of the year (01..12)
              "%-m" => "m",         # Month of the year (1..12)
              # "%M" => "??",         # Minute of the hour (00..59)
              # "%p" => "??",         # Meridian indicator ("AM" or "PM")
              # "%S" => "??",         # Second of the minute (00..60)
              "%Y" => "yy",         # Year with century
              "%y" => "y",          # Year without a century (00..99)
            }
            localized_date_format.gsub(/%\w/) {|match| translations[match]}
          end

          def js_plugin_options
            options = {
              "datepicker" => {
                "dateFormat" => js_date_format,
                "dayNames" => self.class.day_names,
                "dayNamesShort" => self.class.abbr_day_names,
                "dayNamesMin" => self.class.abbr_day_names,
                "firstDay" => 1,
                "monthNames" => self.class.month_names,
                "monthNamesShort" => self.class.abbr_month_names,
                "value" => formatted_date_value,
              },
              "timepicker" => {
                "amPmText" => meridian_indicator? ? ["Am", "Pm"] : ["", ""],
                "hourText" => I18n.t("datetime.prompts.hour", :default => I18n.t("datetime.prompts.hour", :locale => :en)),
                "minuteText" => I18n.t("datetime.prompts.minute", :default => I18n.t("datetime.prompts.minute", :locale => :en)),
                "showPeriod" => meridian_indicator?,
                "value" => formatted_time_value,
              }
            }

            options = options.merge self.class.js_plugin_options
          end

          def localized_format(scope = [:time, :formats])
            format = date_format.to_sym
            I18n.t(format, :scope => scope, :default => [
              I18n.t(format, :scope => scope, :locale => :en),
              I18n.t(self.class.format, :scope => scope, :locale => :en),
            ]).to_s
          end

          def localized_date_format
            localized_format([:date, :formats])
          end

          def localized_time_format
            meridian_indicator? ? "%I:%M %p" : "%H:%M"
          end

          def meridian_indicator?
            strftime_format.include? "%p"
          end

          def parse_input(params)
            params[name] = self.class.normalize(params[name], "#{localized_date_format} #{localized_time_format}") if params[name].present?
          end

          register_instance_option :sort_reverse? do
            true
          end

          register_instance_option :date_format do
            self.class.format
          end

          register_instance_option :formatted_value do
            unless (time = value).nil?
              I18n.l(time, :format => strftime_format)
            else
              "".html_safe
            end
          end

          register_instance_option :partial do
            :form_datetime
          end

          register_instance_option :strftime_format do
            localized_format self.class.i18n_scope
          end
        end
      end
    end
  end
end
