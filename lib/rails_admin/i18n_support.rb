require 'i18n'

module RailsAdmin
  module I18nSupport
    def abbr_day_names
      I18n.t('date.abbr_day_names', raise: true)
    rescue I18n::ArgumentError
      I18n.t('date.abbr_day_names', locale: :en)
    end

    def abbr_month_names
      begin
        names = I18n.t('date.abbr_month_names', raise: true)
      rescue I18n::ArgumentError
        names = I18n.t('date.abbr_month_names', locale: :en)
      end
      names[1..-1]
    end

    def date_format
      I18n.t('date.formats.default', default: I18n.t('date.formats.default', locale: :en))
    end

    def day_names
      I18n.t('date.day_names', raise: true)
    rescue I18n::ArgumentError
      I18n.t('date.day_names', locale: :en)
    end

    def month_names
      begin
        names = I18n.t('date.month_names', raise: true)
      rescue I18n::ArgumentError
        names = I18n.t('date.month_names', locale: :en)
      end
      names[1..-1]
    end
  end
end
