@RailsAdmin ||= {}
@RailsAdmin.I18n = class Locale
  @init: (@locale, @translations)->
    moment.locale(@locale)

  @t:(key) ->
    humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1)
    @translations[key] || humanize
