String.prototype.toCamelCase = function() {
  return this.replace(/^([A-Z])|[\s-_](\w)/g, function(match, p1, p2, offset) {
    if (p2) return p2.toUpperCase();
    return p1.toLowerCase();
  });
};

var FilterComponents = {
  booleanFilterComponent: function (options) {
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
  },
  dateFilterComponent: function (options) {
    var component = {};
    component.additional_control = '<input size="20" class="date additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="20" placeholder="-∞" class="date additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="20" placeholder="∞" class="date additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  },
  datetimeFilterComponent: function (options) {
    var component = {};

    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" name="' + options.operator_name + '">' +
      '<option ' + (options.field_operator == "default" ? 'selected="selected"' : '') + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("date") + '</option>' +
      '<option ' + (options.field_operator == "between" ? 'selected="selected"' : '') + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>' +
      '<option ' + (options.field_operator == "today" ? 'selected="selected"' : '') + ' value="today">' + RailsAdmin.I18n.t("today") + '</option>' +
      '<option ' + (options.field_operator == "yesterday" ? 'selected="selected"' : '') + ' value="yesterday">' + RailsAdmin.I18n.t("yesterday") + '</option>' +
      '<option ' + (options.field_operator == "this_week" ? 'selected="selected"' : '') + ' value="this_week">' + RailsAdmin.I18n.t("this_week") + '</option>' +
      '<option ' + (options.field_operator == "last_week" ? 'selected="selected"' : '') + ' value="last_week">' + RailsAdmin.I18n.t("last_week") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null" >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control = '<input size="25" class="datetime additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input size="25" placeholder="-∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[1] || '') + '" /> ' +
      '<input size="25" placeholder="∞" class="datetime additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="text" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  },
  timestampFilterComponent: function (options) {
    return this.datetimeFilterComponent(options);
  },
  enumFilterComponent: function (options) {
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
  },
  stringFilterComponent: function (options) {
    var control;
    var component = {};
    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" value="' + options.field_operator + '" name="' + options.operator_name + '">' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "like" ? 'selected="selected"' : '') + ' value="like">' + RailsAdmin.I18n.t("contains") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "is" ? 'selected="selected"' : '') + ' value="is">' + RailsAdmin.I18n.t("is_exactly") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "starts_with" ? 'selected="selected"' : '') + ' value="starts_with">' + RailsAdmin.I18n.t("starts_with") + '</option>' +
      '<option data-additional-fieldset="additional-fieldset"' + (options.field_operator == "ends_with" ? 'selected="selected"' : '') + ' value="ends_with">' + RailsAdmin.I18n.t("ends_with") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null">' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>'
    component.additional_control = '<input class="additional-fieldset input-sm form-control" style="display:' + (options.field_operator == "_blank" || options.field_operator == "_present" ? 'none' : 'inline-block') + ';" type="text" name="' + options.value_name + '" value="' + options.field_value + '" />';
    return component;
  },
  textFilterComponent: function (options) {
    return this.stringFilterComponent(options)
  },
  hasManyAssociationFilterComponent: function (options) {
    var component = {};
    if (options.check_boxes) {
      var checked = function (value, applied_filters) {
        return $.inArray(value[1], applied_filters) !== -1 ? 'checked="checked"' : '';
      }
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
  },
  hasAndBelongsToManyAssociationFilterComponent: function (options) {
    return this.hasManyAssociationFilterComponent(options);
  },
  belongsToAssociationFilterComponent: function (options) {
    var select_options = options['select_options'];
    if (select_options.length > 0) {
      return this.hasManyAssociationFilterComponent(options);
    } else  {
      return this.stringFilterComponent(options);
    }
  },
  numberFilterComponent: function (options) {
    var component = {};

    component.control = '<select class="switch-additionnal-fieldsets input-sm form-control" name="' + options.operator_name + '">' +
      '<option ' + (options.field_operator == "default" ? 'selected="selected"' : '') + ' data-additional-fieldset="default" value="default">' + RailsAdmin.I18n.t("number") + '</option>' +
      '<option ' + (options.field_operator == "between" ? 'selected="selected"' : '') + ' data-additional-fieldset="between" value="between">' + RailsAdmin.I18n.t("between_and_") + '</option>' +
      '<option disabled="disabled">---------</option>' +
      '<option ' + (options.field_operator == "_not_null" ? 'selected="selected"' : '') + ' value="_not_null">' + RailsAdmin.I18n.t("is_present") + '</option>' +
      '<option ' + (options.field_operator == "_null" ? 'selected="selected"' : '') + ' value="_null" >' + RailsAdmin.I18n.t("is_blank") + '</option>' +
      '</select>';
    component.additional_control =
      '<input class="additional-fieldset default input-sm form-control" style="display:' + ((!options.field_operator || options.field_operator == "default") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (options.field_value[0] || '') + '" /> ' +
      '<input placeholder="-∞" class="additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (foptions.ield_value[1] || '') + '" /> ' +
      '<input placeholder="∞" class="additional-fieldset between input-sm form-control" style="display:' + ((options.field_operator == "between") ? 'inline-block' : 'none') + ';" type="' + options.field_type + '" name="' + options.value_name + '[]" value="' + (options.field_value[2] || '') + '" />';
    return component;
  },
  integerFilterComponent: function (options) {
    return this.numberFilterComponent(options);
  },
  decimalFilterComponent: function (options) {
    return this.numberFilterComponent(options);
  },
  floatFilterComponent: function (options) {
    return this.numberFilterComponent(options);
  },
  defaultFilterComponent: function (options) {
    return {control: '<input type="text" class="input-sm form-control" name="' + options.value_name + '" value="' + options.field_value + '"/>' }
  },
  create: function(filterOptions){
    var field = filterOptions.field_type.toCamelCase() + 'FilterComponent';
    return this[field](filterOptions);
  }
};

(function ($, componentFactory) {

  var filters;
  
  var filterOptionsHandeler = function (options) {
    return {
      field_label: options['label'],
      field_name: options['name'],
      field_type: options['type'],
      field_value: options['value'],
      field_operator: options['operator'],
      select_options: options['select_options'],
      multi_select: options['multi_select'],
      check_boxes: options['check_boxes'],
      checkbox_values: options['checkbox_values'],
      applied_filters: options['applied_filters'],
      index: options['index'],
      value_name: 'f[' + options['name'] + '][' + options['index'] + '][v]',
      operator_name: 'f[' + options['name'] + '][' + options['index'] + '][o]'
    }
  };

  $.filters = filters = {
    append: function (options) {
      var filterOptions = filterOptionsHandeler(options) || {};
      var component = componentFactory.create(filterOptions);
      var control = component.control;
      var additional_control = component.additional_control;

      var $content = $('<p>')
        .addClass('filter form-search')
        .append('<span class="label label-info form-label"><a href="#delete" class="delete"><i class="fa fa-trash-o fa-fw icon-white"></i>' + filterOptions.field_label + '</a></span>')
        .append('&nbsp;' + control + '&nbsp;' + (additional_control || ''));

      $('#filters_box').append($content);

      $content.find('.date, .datetime').datetimepicker({
        locale: RailsAdmin.I18n.locale,
        showTodayButton: true,
        format: filterOptions['datetimepicker_format']
      });

      $("hr.filters_box:hidden").show('slow');
    }
  };

  $(document).on('click', "#filters a", function (e) {
    e.preventDefault();
    $.filters.append({
      label: $(this).data('field-label'),
      name: $(this).data('field-name'),
      type: $(this).data('field-type'),
      value: $(this).data('field-value'),
      operator: $(this).data('field-operator'),
      select_options: $(this).data('field-options'),
      index: $.now().toString().slice(6, 11),
      datetimepicker_format: $(this).data('field-datetimepicker-format')
    });
  });

  $(document).on('click', "#filters_box .delete", function (e) {
    e.preventDefault();
    form = $(this).parents('form');
    $(this).parents('.filter').remove();
    !$("#filters_box").children().length && $("hr.filters_box:visible").hide('slow');
  });

  $(document).on('click', "#filters_box .switch-select", function (e) {
    e.preventDefault();
    var selected_select = $(this).siblings('select:visible');
    var not_selected_select = $(this).siblings('select:hidden');
    not_selected_select.attr('name', not_selected_select.data('name')).show('slow');
    selected_select.attr('name', null).hide('slow');
    $(this).find('i').toggleClass("icon-plus icon-minus")
  });

  $(document).on('change', "#filters_box .switch-additionnal-fieldsets", function (e) {
    var selected_option = $(this).find('option:selected');
    if (klass = $(selected_option).data('additional-fieldset')) {
      $(this).siblings('.additional-fieldset:not(.' + klass + ')').hide('slow');
      $(this).siblings('.' + klass).show('slow');
    } else {
      $(this).siblings('.additional-fieldset').hide('slow');
    }
  });
})(jQuery, FilterComponents);
