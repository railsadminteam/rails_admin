export default {
  locale: null,
  translations: null,
  init(locale, translations) {
    this.locale = locale;
    this.translations = translations;
    if (typeof this.translations === "string") {
      this.translations = JSON.parse(this.translations);
    }
  },
  t(key) {
    var humanize;
    humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1);
    return this.translations[key] || humanize;
  },
};
