(function (components) {

  components.enum_filter_component = function (options) {
    var component = {};
    var multiple_values = ((options.field_value instanceof Array) ? true : false)
    component.control = '<select style="display:' + (multiple_values ? 'none' : 'inline-block') + '" ' + (multiple_values ? '' : 'name="' + options.value_name + '"') + ' data-name="' + options.value_name + '" class="select-single input-sm form-control">' +
      '<option value="_discard">...</option>' +
      '<option ' + (options.field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_value == "_blank" ? 'selected="selected"' : '') + ' value="_blank">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      options.select_options +
      '</select>' +
      '<select multiple="multiple" style="display:' + (multiple_values ? 'inline-block' : 'none') + '" ' + (multiple_values ? 'name="' + options.value_name + '[]"' : '') + ' data-name="' + options.value_name + '[]" class="select-multiple input-sm form-control">' +
      options.select_options +
      '</select> ' +
      '<a href="#" class="switch-select"><i class="icon-' + (multiple_values ? 'minus' : 'plus') + '"></i></a>';
    return component;
  }

})(FilterBoxComponents);