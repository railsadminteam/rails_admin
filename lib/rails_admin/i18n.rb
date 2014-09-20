require 'i18n'

module RailsAdmin
  module I18n
    include ::I18n

    def locale
      RailsAdmin.config.locale || ::I18n.locale
    end

    def translate(key, options = {})
      ::I18n.translate(key, {locale: locale}.merge(options))
    end
    alias_method :t, :translate

    def translate!(key, options = {})
      translate(key, options.merge(raise: true))
    end
    alias_method :t!, :translate!

    def localize(key, options = {})
      ::I18n.localize(key, {locale: locale}.merge(options))
    end
    alias_method :l, :localize

    module_function :t
    module_function :translate
    module_function :t!
    module_function :translate!
    module_function :l
    module_function :localize
    module_function :locale
  end
end
