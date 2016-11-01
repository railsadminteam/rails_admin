(function (components) {

  var helpers = components.helpers;

  components.datetime_filter_component = function (options) {
    var component = {};
    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" name="' + options.operator_name + '">' +
      '<option ' + helpers.default_operator_selected(options) + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("date") + '</option>' +
      '<option ' + helpers.between_operator_display(options) + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>' +
      '<option ' + helpers.today_filter_selected(options) + ' value="today">' + RailsAdmin.I18n.t("today") + '</option>' +
      '<option ' + helpers.yesterday_operator_selected(options) + ' value="yesterday">' + RailsAdmin.I18n.t("yesterday") + '</option>' +
      '<option ' + helpers.this_week_operator_selected(options) + ' value="this_week">' + RailsAdmin.I18n.t("this_week") + '</option>' +
      '<option ' + helpers.last_week_operator_selected(options) + ' value="last_week">' + RailsAdmin.I18n.t("last_week") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + helpers.not_null_operator_selected(options) + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + helpers.null_operator_selected(options) + ' value="_null" >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control = '<input size="25" class="datetime additional-fieldset default input-sm form-control" style="display:' + helpers.default_filter_display(options) + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="25" placeholder="-∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + helpers.between_operator_display(options) + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="25" placeholder="∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + helpers.between_operator_display(options) + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  };

  components.date_filter_component = function (options) {
    var component = {};
    component.control = this.datetime_filter_component(options).control;
    component.additional_control = '<input size="20" class="date additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator === "default") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="20" placeholder="-∞" class="date additional-fieldset between input-sm form-control" style="display:' + helpers.between_operator_display(options) + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="20" placeholder="∞" class="date additional-fieldset between input-sm form-control" style="display:' + helpers.between_operator_display(options) + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  };

  components.timestamp_filter_component = function (options) {
    return this.datetime_filter_component(options);
  };

}(FilterBoxComponents));
