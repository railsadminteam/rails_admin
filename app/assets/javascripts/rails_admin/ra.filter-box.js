(function ($, componentFactory) {

  var filters;
  
  var filterOptionsTransformer = function (options) {
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
      var filterOptions = filterOptionsTransformer(options);
      var component = componentFactory.create(filterOptions);

      var $content = $('<p>')
        .addClass('filter form-search')
        .append('<span class="label label-info form-label"><a href="#delete" class="delete"><i class="fa fa-trash-o fa-fw icon-white"></i>' + filterOptions.field_label + '</a></span>')
        .append('&nbsp;' + component.control + '&nbsp;' + (component.additional_control || ''));

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
})(jQuery, FilterBoxComponents);
