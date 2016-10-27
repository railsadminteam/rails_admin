(function (components) {

  components.has_many_association_filter_component = function (options) {
    var component = {};
    if (options.check_boxes) {
      var checked = function (value, applied_filters) {
        return $.inArray(value[1], applied_filters) !== -1 ? 'checked="checked"' : '';
      };
      var new_checkbox = function (value) {
        return '<label class="checkbox-inline" for="' + options.value_name + '[]">' +
          '<input style="display:inline-block" name="' + options.value_name + '[]" data-name="' + options.value_name + '[]" class="checkbox input-sm form-control" type="checkbox" value="' + value[1] + '" ' + checked(value, options.applied_filters) + ' />' +
          '' + value[0] +
          '</label>';
      };
      component.control = options.checkbox_values.map(function (value) {
        return new_checkbox(value)
      }).join('\n');
    } else {
      component.control = '<select style="display:' + (options.multi_select ? 'none' : 'inline-block') + '" ' + (options.multi_select ? '' : 'name="' + options.value_name + '"') + ' data-name="' + options.value_name + '" class="select-single input-sm form-control">' +
        '<option value="_discard">...</option>' +
        '<option ' + (options.field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">' + RailsAdmin.I18n.t("is_present") + '</option>' +
        '<option ' + (options.field_value == "_blank" ? 'selected="selected"' : '') + ' value="_blank">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
        '<option disabled="disabled">---------</option>' +
        options.select_options +
        '</select>' +
        '<a href="#" class="switch-select"><i class="icon-' + (options.multi_select ? 'minus' : 'plus') + '"></i></a>';
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

})(FilterBoxComponents);