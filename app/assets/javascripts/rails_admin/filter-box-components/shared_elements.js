(function(components){

  var shared_elements = components.shared_elements;
  var helpers = components.helpers;

  shared_elements.between_and_default_options = function (options) {
    return '<option ' + helpers.default_operator_selected(options) + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("number") + '</option>' +
           '<option ' + helpers.between_operator_selected(options) + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>';
  }

}(FilterBoxComponents));