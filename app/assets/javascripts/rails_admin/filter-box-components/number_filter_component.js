(function (components) {

  components.number_filter_component = function (options) {
    var component = {};

    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" name="' + options.operator_name + '">' +
      '<option ' + (options.field_operator == "default" ? 'selected="selected"' : '') + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("number") + '</option>' +
      '<option ' + (options.field_operator == "between" ? 'selected="selected"' : '') + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null" >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control =
      '<input class="additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input placeholder="-∞" class="additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (foptions.ield_value[1] || '') + '" /> ' +
      '<input placeholder="∞" class="additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  };

  components.integer_filter_component = function (options) {
    return this.number_filter_component(options);
  };

  components.decimal_filter_component = function (options) {
    return this.number_filter_component(options);
  };

  components.float_filter_component = function (options) {
    return this.number_filter_component(options);
  };

})(FilterBoxComponents);