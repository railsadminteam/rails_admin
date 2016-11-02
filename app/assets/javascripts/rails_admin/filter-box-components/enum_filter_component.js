
(function (components) {

  var helpers = components.helpers;

  components.enum_filter_component = function (options) {
    var component = {};
    var multiple_values = (options.field_value instanceof Array);
    component.control = '<select style="display:' + (multiple_values ? 'none' : 'inline-block') + '" ' + (multiple_values ? '' : 'name="' + options.value_name + '"') + ' data-name="' + options.value_name + '" class="select-single input-sm form-control">' +
      '<option value="_discard">...</option>' +
      '<option ' + helpers.present_operator_selected(options) + ' value="_present">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + helpers.blank_operator_selected(options) + ' value="_blank">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      options.select_options +
      '</select>' +
      '<select multiple="multiple" style="display:' + helpers.multiple_values_display(multiple_values, options) + ' data-name="' + options.value_name + '[]" class="select-multiple input-sm form-control">' +
      options.select_options +
      '</select> ' +
      '<a href="#" class="switch-select"><i class="icon-' + helpers.plus_or_minus_icon(multiple_values) + '"></i></a>';
    return component;
  }

}(FilterBoxComponents));