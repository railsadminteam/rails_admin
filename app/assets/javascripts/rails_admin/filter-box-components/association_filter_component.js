(function (components) {

  var helpers = components.helpers;

  components.has_many_association_filter_component = function (options) {
    var component = {};
    if (options.check_boxes) {
      component.control = options.checkbox_values.map(function (value) {
        return helpers.new_checkbox(value, options);
      }).join('\n');
    } else {
      component.control = '<select style="display:' + helpers.select_input_display(options) + 'class="select-single input-sm form-control">' +
        '<option value="_discard">...</option>' +
        '<option ' + helpers.present_operator_selected(options) + RailsAdmin.I18n.t("is_present") + '</option>' +
        '<option ' + helpers.blank_operator_selected(options) + ' value="_blank">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
        '<option disabled="disabled">---------</option>' +
        options.select_options +
        '</select>' +
        '<a href="#" class="switch-select"><i class="icon-' + helpers.plus_or_minus_icon(options.multi_select) + '"></i></a>';
    }
    return component;
  };

  components.has_and_belongs_to_many_association_filter_component = function (options) {
    return this.has_many_association_filter_component(options);
  };

  components.belongs_to_association_filter_component = function (options) {
    var select_options = options['select_options'];
    if (select_options.length > 0) {
      return this.has_many_association_filter_component(options);
    }
    return this.string_filter_component(options);
  };

}(FilterBoxComponents));