class @RailsAdmin
@RailsAdmin.I18n = class Locale
  @init: (@locale)->
  @t:(key) ->
    humanize = key.charAt(0).toUpperCase() + key.replace("_", " ").slice(1)
    @locale[key] || humanize
