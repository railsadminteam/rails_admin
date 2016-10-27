(function (components) {

  components.boolean_filter_component = function (options) {
    var component = {};
    component.control = '<select class="input-sm form-control" name="' + options.value_name + '">' +
      '<option value="_discard">...</option>' +
      '<option value="true"' + (options.field_value == "true" ? 'selected="selected"' : '') + '>' + RailsAdmin.I18n.t("true") + '</option>' +
      '<option value="false"' + (options.field_value == "false" ? 'selected="selected"' : '') + '>' + RailsAdmin.I18n.t("false") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_value == "_blank" ? 'selected="selected"' : '') + ' value="_blank"  >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    return component;
  };

})(FilterBoxComponents);
