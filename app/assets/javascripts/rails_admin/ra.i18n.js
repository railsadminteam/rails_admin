(function() {
  var Locale;

  this.RailsAdmin || (this.RailsAdmin = {});

  this.RailsAdmin.I18n = Locale = (function() {
    function Locale() {}

    Locale.init = function(locale, translations) {
      this.locale = locale;
      this.translations = translations;
      moment.locale(this.locale);
      if (typeof this.translations === "string") {
        this.translations = JSON.parse(this.translations);
      }
    };

    Locale.t = function(key) {
      var humanize;
      humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1);
      return this.translations[key] || humanize;
    };

    return Locale;

  })();

}).call(this);
