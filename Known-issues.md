### Locale is being forced to :en whereas `config.i18n.default_locale = :de`

Reason: RailsAdmin DSL needs access to locale before default_locale being set by application.rb

See: https://github.com/sferik/rails_admin/issues/746

Workaround: add `I18n.default_locale = :de` inside RailsAdmin's initializer (before model configs)