(function($) {
  
  var filters;
  
  $.filters = filters = {
    append: function(field_label, field_name, field_type, field_value, field_operator, field_options, index) {
      var value_name = 'filters[' +  field_name + '][' + index + '][value]';
      var operator_name = 'filters[' +  field_name + '][' + index + '][operator]';
      switch(field_type) {
        case 'boolean': 
          var control = '<select name="' + value_name + '">' + 
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
          var control = '<select class="switch-additionnal-fieldsets" name="' + operator_name + '">' + 
            '<option data-additional-fieldset="false" value="_discard">...</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "today"     ? 'selected="selected"' : '') + ' value="today">Today</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "yesterday" ? 'selected="selected"' : '') + ' value="yesterday">Yesterday</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "this_week" ? 'selected="selected"' : '') + ' value="this_week">This week</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "last_week" ? 'selected="selected"' : '') + ' value="last_week">Last week</option>' +
            '<option data-additional-fieldset="true" ' + (field_operator == "less_than" ? 'selected="selected"' : '') + ' value="less_than">Less than ... days ago</option>' +
            '<option data-additional-fieldset="true" ' + (field_operator == "more_than" ? 'selected="selected"' : '') + ' value="more_than">More than ... days ago</option>' +
            '<option disabled="disabled">---------</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_present"  ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_blank"    ? 'selected="selected"' : '') + ' value="_blank" >Is blank</option>' +
          '</select>' +
          '<input class="additional-fieldset text_field" style="display:' + (field_operator == "less_than" || field_operator == "more_than" ? 'block' : 'none') + ';" type="text" name="' + value_name + '" value="' + field_value + '" /> ';
          break;
        case 'enum':
          field_options = $j('<div/>').html(field_options).text(); // entities decode
          var control = '<select name="' + value_name + '">' + 
            '<option value="_discard">...</option>' +
            field_options + 
            '<option disabled="disabled">---------</option>' +
            '<option ' + (field_value == "_present" ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
            '<option ' + (field_value == "_blank"   ? 'selected="selected"' : '') + ' value="_blank"  >Is blank</option>' +
          '</select>';
          break;
        case 'string':
        case 'text':
        case 'belongs_to_association':
          var control = '<select class="switch-additionnal-fieldsets" value="' + field_operator + '" name="' + operator_name + '">' + 
            '<option data-additional-fieldset="true"'  + (field_operator == "like"        ? 'selected="selected"' : '') + ' value="like">Contains</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "is"          ? 'selected="selected"' : '') + ' value="is">Is exactly</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "starts_with" ? 'selected="selected"' : '') + ' value="starts_with">Starts with</option>' +
            '<option data-additional-fieldset="true"'  + (field_operator == "ends_with"   ? 'selected="selected"' : '') + ' value="ends_with">Ends with</option>' +
            '<option disabled="disabled">---------</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_present"    ? 'selected="selected"' : '') + ' value="_present">Is present</option>' +
            '<option data-additional-fieldset="false"' + (field_operator == "_blank"      ? 'selected="selected"' : '') + ' value="_blank">Is blank</option>' +
          '</select>' +
          '<input class="additional-fieldset text_field" style="display:' + (field_operator == "_blank" || field_operator == "_present" ? 'none' : 'block') + ';" type="text" name="' + value_name + '" value="' + field_value + '" /> ';
          break;
        default:
          var control = '<input type="text" name="' + value_name + '" value="' + field_value + '" class="text_field"/> ';
          break;
      }
    
      $('#filters_box').append(
        '<div class="filter new" style="clear:both;">' + 
          '<div class="ui-state-default ui-corner-all"><span alt="delete" class="delete ui-icon ui-icon-trash" data-disabler-name="filters[' +  field_name + '][' + index + '][disabled]" style="cursor:pointer" title="delete"></span></div>' +
          '<label>' + field_label + '</label>' + 
          control +
        '</div>'
      );
      
      // this ensures that each select is only 'uniformed' once:
      $("#filters_box .new select").uniform();
      $("#filters_box .new").removeClass("new");
    }
  }

  $(document).ready(function() {
    $("#filter_select").bind('change', function() {
      var option = $(this).find('option:selected')
      $(this).val(''); // reset select
    
      $.filters.append(
        option.data('field-label'), 
        option.data('field-name'), 
        option.data('field-type'), 
        option.data('field-value'), 
        option.data('field-operator'), 
        option.data('field-options'),
        Date.now()
      );
    });
  
    $('#filters_box .delete').live('click', function() {
      $(this).parents('.filter').hide();
      $(this).append('<input type="hidden" name="' + $(this).data('disabler-name') + '" value="true" />')
    });
  
    $('#filters_box .switch-additionnal-fieldsets').live('change', function() {
      var selected_option = $(this).find('option:selected');
      if($(selected_option).data('additional-fieldset')) {
        $(this).parent().siblings('.additional-fieldset').val('');
        $(this).parent().siblings('.additional-fieldset').show();
      } else {
        $(this).parent().siblings('.additional-fieldset').hide();
      }
    });
  });
})( jQuery );