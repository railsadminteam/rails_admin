
(function (components) {
  var helpers = components.helpers;

  components.string_filter_component = function (options) {
    var control;
    var component = {};
    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" value="' + options.field_operator + '" name="' + options.operator_name + '">' +
      '<option data-additional-fieldset="additional-fieldset"' + helpers.like_operator_selected(options) + ' value="like">' + RailsAdmin.I18n.t("contains") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + helpers.is_operator_selected(options) + ' value="is">' + RailsAdmin.I18n.t("is_exactly") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + helpers.starts_with_operstor_selected(options) + ' value="starts_with">' + RailsAdmin.I18n.t("starts_with") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + helpers.ends_with_operator_selected(options) + ' value="ends_with">' + RailsAdmin.I18n.t("ends_with") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + helpers.not_null_operator_selected(options) + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + helpers.null_operator_selected(options) + ' value="_null">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control = '<input class="additional-fieldset input-sm form-control" style="display:' + (options.field_operator === "_blank" || options.field_operator === "_present" ? 'none' : 'inline-block') + ';" type="text" name="' + options.value_name + '" value="' + options.field_value + '" />';
    return component;
  };

  components.text_filter_component = function (options) {
    return this.string_filter_component(options)
  };

}(FilterBoxComponents));
