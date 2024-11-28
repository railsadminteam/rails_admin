var I18n = {
  locale: null,
  translations: null,
  init: function(locale, translations) {
    this.locale = locale;
    this.translations = translations;
    if (typeof this.translations === "string") {
      this.translations = JSON.parse(this.translations);
    }
  },
  t: function(key) {
    var humanize;
    humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1);
    return this.translations[key] || humanize;
  },
};

export default I18n;
