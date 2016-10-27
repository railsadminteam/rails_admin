(function (components) {

  components.datetime_filter_component = function (options) {
    var component = {};
    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" name="' + options.operator_name + '">' +
      '<option ' + (options.field_operator == "default" ? 'selected="selected"' : '') + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("date") + '</option>' +
      '<option ' + (options.field_operator == "between" ? 'selected="selected"' : '') + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>' +
      '<option ' + (options.field_operator == "today" ? 'selected="selected"' : '') + ' value="today">' + RailsAdmin.I18n.t("today") + '</option>' +
      '<option ' + (options.field_operator == "yesterday" ? 'selected="selected"' : '') + ' value="yesterday">' + RailsAdmin.I18n.t("yesterday") + '</option>' +
      '<option ' + (options.field_operator == "this_week" ? 'selected="selected"' : '') + ' value="this_week">' + RailsAdmin.I18n.t("this_week") + '</option>' +
      '<option ' + (options.field_operator == "last_week" ? 'selected="selected"' : '') + ' value="last_week">' + RailsAdmin.I18n.t("last_week") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null" >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control = '<input size="25" class="datetime additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="25" placeholder="-∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="25" placeholder="∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  };

  components.date_filter_component = function (options) {
    var component = {};
    component.control = this.datetime_filter_component(options).control;
    component.additional_control = '<input size="20" class="date additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="20" placeholder="-∞" class="date additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="20" placeholder="∞" class="date additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  };

  components.timestamp_filter_component = function (options) {
    return this.datetime_filter_component(options);
  };

})(FilterBoxComponents);
