(function (helpers) {
  
  var selected_state = 'selected="selected"';
  
  helpers.like_operator_selected = function (options) {
    return (options.field_operator === "like" ? selected_state : '');
  };
  
  helpers.is_operator_selected = function (options) {
    return (options.field_operator === "is" ? selected_state : '');
  };
  
  helpers.starts_with_operstor_selected = function (options) {
    return (options.field_operator === "starts_with" ? selected_state : '');
  };
  
  helpers.ends_with_operator_selected = function (options) {
    return (options.field_operator === "ends_with" ? selected_state : '');
  };

  helpers.default_operator_selected = function (options) {
    return (options.field_operator === "default" ? selected_state : '');
  };

  helpers.between_operator_selected = function (options) {
    return (options.field_operator === "between" ? selected_state : '');
  };

  helpers.not_null_operator_selected = function (options) {
    return (options.field_operator === "_not_null" ? selected_state : '');
  };

  helpers.null_operator_selected = function (options) {
    return (options.field_operator === "_null" ? selected_state : '');
  };

  helpers.today_operator_selected = function (options) {
    return (options.field_operator === "today" ? selected_state : '')
  };
  helpers.yesterday_operator_selected = function (options) {
    return (options.field_operator === "yesterday" ? selected_state : '')
  };
  helpers.last_week_operator_selected = function (options) {
    return (options.field_operator === "last_week" ? selected_state : '')
  };
  helpers.this_week_operator_selected = function (options) {
    return (options.field_operator === "this_week" ? selected_state : '')
  };
  helpers.true_operator_selected = function (options) {
    return (options.field_value === "true" ? selected_state : '');
  };
  helpers.false_operator_selected = function (options) {
    return (options.field_value === "false" ? selected_state : '');
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

  helpers.new_checkbox = function (value, options) {
    return '<label class="checkbox-inline" for="' + options.value_name + '[]">' +
      '<input style="display:inline-block" name="' + options.value_name + '[]" data-name="' + options.value_name + '[]" class="checkbox input-sm form-control" type="checkbox" value="' + value[1] + '" ' + helpers.checked(value, options.applied_filters) + ' />' +
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