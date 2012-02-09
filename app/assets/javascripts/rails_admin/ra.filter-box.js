(function($) {

  var filters;

  $.filters = filters = {
    append: function(field_label, field_name, field_type, field_value, field_operator, field_options, multiple_values, index) {
      var value_name = 'f[' +  field_name + '][' + index + '][v]';
      var operator_name = 'f[' +  field_name + '][' + index + '][o]';
      switch(field_type) {
        case 'boolean':
          var control = '<select class="input-small" name="' + value_name + '">' +
            '<option value="_discard">...</option>' +
            '<option value="true"' + (field_value == "true" ? 'selected="selected"' : '') + '>True</option>' +
            '<option value="false"' + (field_value == "false" ? 'selected="selected"' : '') + '>False</option>' +
            '<option disabled="disabled">---------</option>' +
            '<option ' + (field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
            '<option ' + (field_value == "_blank"   ? 'selected="selected"' : '') + ' value="_blank"  >Is blank</option>' +
          '</select>';
          break;
        case 'date':
        case 'datetime':
        case 'timestamp':
          var control = '<select class="switch-additionnal-fieldsets input-small" name="' + operator_name + '">' +
            '<option data-additional-fieldset="false" value="_discard">...</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "today"     ? 'selected="selected"' : '') + ' value="today">Today</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "yesterday" ? 'selected="selected"' : '') + ' value="yesterday">Yesterday</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "this_week" ? 'selected="selected"' : '') + ' value="this_week">This week</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "last_week" ? 'selected="selected"' : '') + ' value="last_week">Last week</option>' +
            '<option data-additional-fieldset="true" ' + (field_operator == "less_than" ? 'selected="selected"' : '') + ' value="less_than">Less than ... days ago</option>' +
            '<option data-additional-fieldset="true" ' + (field_operator == "more_than" ? 'selected="selected"' : '') + ' value="more_than">More than ... days ago</option>' +
            '<option data-additional-fieldset="true" ' + (field_operator == "mmddyyyy"	? 'selected="selected"' : '') + ' value="mmddyyyy">On specific date (mmddyyyy)</option>' +
            '<option disabled="disabled">---------</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_not_null"  ? 'selected="selected"' : '') + ' value="_not_null">Is present</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_null"    ? 'selected="selected"' : '') + ' value="_null" >Is blank</option>' +
          '</select>'
          var additional_control = '<input class="additional-fieldset input-small" style="display:' + (field_operator == "less_than" || field_operator == "more_than" || field_operator == "mmddyyyy" ? 'inline-block' : 'none') + ';" type="text" name="' + value_name + '" value="' + field_value + '" /> ';
          break;
        case 'enum':
          var field_options = $('<div/>').html(field_options).text(); // entities decode
          var control = '<select style="display:' + (multiple_values ? 'none' : 'inline-block') + '" ' + (multiple_values ? '' : 'name="' + value_name + '"') + ' data-name="' + value_name + '" class="select-single input-small">' +
              '<option value="_discard">...</option>' +
              '<option ' + (field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
              '<option ' + (field_value == "_blank"   ? 'selected="selected"' : '') + ' value="_blank">Is blank</option>' +
              '<option disabled="disabled">---------</option>' +
              field_options +
            '</select>' + 
            '<select multiple="multiple" style="display:' + (multiple_values ? 'inline-block' : 'none') + '" ' + (multiple_values ? 'name="' + value_name + '[]"' : '') + ' data-name="' + value_name + '[]" class="select-multiple input-small">' +
              field_options +
            '</select> ' +
            '<a href="#" class="switch-select"><i class="icon-' + (multiple_values ? 'minus' : 'plus') + '"></i></a>';
        break;
        case 'string':
        case 'text':
        case 'belongs_to_association':
          var control = '<select class="switch-additionnal-fieldsets input-small" value="' + field_operator + '" name="' + operator_name + '">' +
            '<option data-additional-fieldset="true"'  + (field_operator == "like"        ? 'selected="selected"' : '') + ' value="like">Contains</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "is"          ? 'selected="selected"' : '') + ' value="is">Is exactly</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "starts_with" ? 'selected="selected"' : '') + ' value="starts_with">Starts with</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "ends_with"   ? 'selected="selected"' : '') + ' value="ends_with">Ends with</option>' +
            '<option disabled="disabled">---------</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_present"    ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_blank"      ? 'selected="selected"' : '') + ' value="_blank">Is blank</option>' +
          '</select>'
          var additional_control = '<input class="additional-fieldset input-small" style="display:' + (field_operator == "_blank" || field_operator == "_present" ? 'none' : 'inline-block') + ';" type="text" name="' + value_name + '" value="' + field_value + '" /> ';
          break;
        default:
          var control = '<input type="text" class="input-small" name="' + value_name + '" value="' + field_value + '"/> ';
          break;
      }

      var content = '<p class="filter form-search">' +
        '<span class="label label-info form-label"><a href="#" class="delete"><i class="icon-trash icon-white"></i></a> ' + field_label + '</span> ' +
        control + " " +
        (additional_control || '') +
      '</div> ';
      $('#filters_box').append(content);
      $("hr.filters_box:hidden").show('slow');
    }
  }

  $("#filters a").live('click', function(e) {
    e.preventDefault();
    $.filters.append(
      $(this).data('field-label'),
      $(this).data('field-name'),
      $(this).data('field-type'),
      $(this).data('field-value'),
      $(this).data('field-operator'),
      $(this).data('field-options'),
      $(this).data('field-multiple_values'),
      $.now().toString().slice(7,11)
    );
  });

  $('#filters_box .delete').live('click', function(e) {
    e.preventDefault();
    form = $(this).parents('form');
    $(this).parents('.filter').remove();
    !$("#filters_box").children().length && $("hr.filters_box:visible").hide('slow');
    form.submit();
  });

  $('#filters_box .switch-select').live('click', function(e) {
    e.preventDefault();
    var selected_select = $(this).siblings('select:visible');
    var not_selected_select = $(this).siblings('select:hidden');
    not_selected_select.attr('name', not_selected_select.data('name')).show('slow');
    selected_select.attr('name', null).hide('slow');
    $(this).find('i').toggleClass("icon-plus icon-minus")
  });

  $('#filters_box .switch-additionnal-fieldsets').live('change', function() {
    var selected_option = $(this).find('option:selected');
    if($(selected_option).data('additional-fieldset')) {
      $(this).siblings('.additional-fieldset').show('slow');
    } else {
      $(this).siblings('.additional-fieldset').hide('slow');
    }
  });
})( jQuery );
