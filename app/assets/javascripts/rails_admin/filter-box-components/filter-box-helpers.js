(function (helpers) {

  helpers.selected = function () {
    return 'selected="selected"';
  };

  helpers.like_operator_selected = function (options) {
    return (options.field_operator === "like" ? selected() : '');
  };
  
  helpers.is_operator_selected = function (options) {
    return (options.field_operator === "is" ? selected() : '');
  };
  
  helpers.starts_with_operstor_selected = function (options) {
    return (options.field_operator === "starts_with" ? selected() : '');
  };
  
  helpers.ends_with_operator_selected = function (options) {
    return (options.field_operator === "ends_with" ? selected() : '');
  };

  helpers.default_operator_selected = function (options) {
    return (options.field_operator === "default" ? selected() : '');
  };

  helpers.between_operator_selected = function (options) {
    return (options.field_operator === "between" ? selected() : '');
  };

  helpers.not_null_operator_selected = function (options) {
    return (options.field_operator === "_not_null" ? selected() : '');
  };

  helpers.null_operator_selected = function (options) {
    return (options.field_operator === "_null" ? selected() : '');
  };

  helpers.today_operator_selected = function (options) {
    return (options.field_operator === "today" ? 'selected="selected"' : '')
  };
  helpers.yesterday_operator_selected = function (options) {
    return (options.field_operator === "yesterday" ? 'selected="selected"' : '')
  };
  helpers.last_week_operator_selected = function (options) {
    return (options.field_operator === "last_week" ? 'selected="selected"' : '')
  };
  helpers.this_week_operator_selected = function (options) {
    return (options.field_operator === "this_week" ? 'selected="selected"' : '')
  };
  helpers.true_operator_selected = function (options) {
    return (options.field_value === "true" ? 'selected="selected"' : '');
  };
  helpers.false_operator_selected = function (options) {
    return (options.field_value === "false" ? 'selected="selected"' : '');
  };

  helpers.default_filter_display = function (options) {
    return ((!options.field_operator || options.field_operator === "default") ? 'inline-block' : 'none');
  };
  
  helpers.between_operator_display = function (options) {
    return ((options.field_operator === "between") ? 'inline-block' : 'none');
  };

  helpers.checked = function (value, applied_filters) {
    return $.inArray(value[1], applied_filters) !== -1 ? 'checked="checked"' : '';
  };

  helpers.new_checkbox = function (value) {
    return '<label class="checkbox-inline" for="' + options.value_name + '[]">' +
      '<input style="display:inline-block" name="' + options.value_name + '[]" data-name="' + options.value_name + '[]" class="checkbox input-sm form-control" type="checkbox" value="' + value[1] + '" ' + checked(value, options.applied_filters) + ' />' +
      '' + value[0] +
      '</label>';
  };

  helpers.select_input_display = function (options) {
    return (options.multi_select ? 'none' : 'inline-block') + '" ' + (options.multi_select ? '' : 'name="' + options.value_name + '"') + ' data-name="' + options.value_name + ' ';
  };

  helpers.present_operator_selected = function (options) {
    return (options.field_value === "_present" ? 'selected="selected"' : '') + ' value="_present">';
  };
  helpers.blank_operator_selected = function (options) {
    return (options.field_value === "_blank" ? 'selected="selected"' : '');
  };
  helpers.plus_or_minus_icon = function (multi) {
    return (multi ? 'minus' : 'plus');
  };

  helpers.multiple_values_display = function (multiple_values, options) {
    return (multiple_values ? 'inline-block' : 'none') + '" ' + (multiple_values ? 'name="' + options.value_name + '[]"' : '');
  };
  
}(FilterBoxComponents.helpers));