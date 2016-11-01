
(function (components) {

  var helpers = components.helpers;

  components.boolean_filter_component = function (options) {
    var component = {};
    component.control = '<select class="input-sm form-control" name="' + options.value_name + '">' +
      '<option value="_discard">...</option>' +
      '<option value="true"' + true_operator_selected(options) + '>' + RailsAdmin.I18n.t("true") + '</option>' +
      '<option value="false"' + false_operator_selected(options) + '>' + RailsAdmin.I18n.t("false") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + helpers.present_operator_selected(options) + ' value="_present">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + helpers.blank_operator_selected(options) + ' value="_blank"  >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    return component;
  };

}(FilterBoxComponents));
