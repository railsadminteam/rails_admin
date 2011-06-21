(function($) {
  
  var filters;
  
  $.filters = filters = {
    append: function(field_label, field_name, field_type, field_value, field_operator, field_options, index) {
      var value_name = 'filters[' +  field_name + '][' + index + '][value]';
      var operator_name = 'filters[' +  field_name + '][' + index + '][operator]';
      switch(field_type) {
        case 'boolean': 
          var control = '<select name="' + value_name + '">' + 
            '<option value="true"' + (field_value == "true" ? 'selected="selected"' : '') + '>True</option>' +
            '<option value="false"' + (field_value == "false" ? 'selected="selected"' : '') + '>False</option>' +
          '</select>';
          break;
        case 'date':
        case 'datetime':
        case 'timestamp':
          var control = '<select class="switch-additionnal-fieldsets" name="' + operator_name + '">' + 
            '<option ' + (field_operator == "today"     ? 'selected="selected"' : '') + ' value="today"     data-additional-fieldset="false">Today</option>' +
            '<option ' + (field_operator == "yesterday" ? 'selected="selected"' : '') + ' value="yesterday" data-additional-fieldset="false">Yesterday</option>' +
            '<option ' + (field_operator == "this_week" ? 'selected="selected"' : '') + ' value="this_week" data-additional-fieldset="false">This week</option>' +
            '<option ' + (field_operator == "last_week" ? 'selected="selected"' : '') + ' value="last_week" data-additional-fieldset="false">Last week</option>' +
            '<option ' + (field_operator == "less_than" ? 'selected="selected"' : '') + ' value="less_than" data-additional-fieldset="true">Less than ... days ago</option>' +
            '<option ' + (field_operator == "more_than" ? 'selected="selected"' : '') + ' value="more_than" data-additional-fieldset="true">More than ... days ago</option>' +
          '</select>' +
          '<input class="additional-fieldset text_field" style="display:' + (field_operator == "less_than" || field_operator == "more_than" ? 'block' : 'none') + ';" type="text" name="' + value_name + '" value="' + field_value + '" /> ';
          break;
        case 'enum':
          field_options = $j('<div/>').html(field_options).text(); // entities decode
          var control = '<select name="' + value_name + '">' + 
            field_options + 
          '</select>';
          break;
        case 'string':
        case 'text':
          var control = '<select value="' + field_operator + '" name="' + operator_name + '">' + 
            '<option value="like" ' + (field_operator == "like" ? 'selected="selected"' : '') + '>Like</option>' +
            '<option value="starts_with" ' + (field_operator == "starts_with" ? 'selected="selected"' : '') + '>Starts with</option>' +
            '<option value="ends_with" ' + (field_operator == "ends_with" ? 'selected="selected"' : '') + '>Ends with</option>' +
            '<option value="is" ' + (field_operator == "is" ? 'selected="selected"' : '') + '>Is exactly</option>' +
          '</select>' +
          '<input type="text" name="' + value_name + '" value="' + field_value + '" class="text_field"/> ';
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