(function (components) {

  components.string_filter_component = function (options) {
    var control;
    var component = {};
    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" value="' + options.field_operator + '" name="' + options.operator_name + '">' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "like" ? 'selected="selected"' : '') + ' value="like">' + RailsAdmin.I18n.t("contains") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "is" ? 'selected="selected"' : '') + ' value="is">' + RailsAdmin.I18n.t("is_exactly") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "starts_with" ? 'selected="selected"' : '') + ' value="starts_with">' + RailsAdmin.I18n.t("starts_with") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "ends_with" ? 'selected="selected"' : '') + ' value="ends_with">' + RailsAdmin.I18n.t("ends_with") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>'
    component.additional_control = '<input class="additional-fieldset input-sm form-control" style="display:' + (options.field_operator == "_blank" || options.field_operator == "_present" ? 'none' : 'inline-block') + ';" type="text" name="' + options.value_name + '" value="' + options.field_value + '" />';
    return component;
  };

  components.text_filter_component = function (options) {
    return this.string_filter_component(options)
  };

})(FilterBoxComponents);
