$j(document).ready(function($){
  
  $("#filter_select").bind('change', function() {
    
    var option = $(this).find('option:selected')
    $(this).val(''); // reset select
    append_filter(option.data('field-label'), option.data('field-name'), option.data('field-type'), option.data('field-value'), option.data('field-operator'), $j('<div/>').text(option.data('field-options')).html());
  });
  
  $('#filters_box .delete').live('click', function() {
    $(this).parents('.filter').hide();
    $(this).append('<input type="hidden" name="' + $(this).data('disabler-name') + '" value="true" />')
  });
});


var append_filter = function(field_label, field_name, field_type, field_value, field_operator, field_options) {
  switch(field_type) {
    case 'boolean': 
      var control = '<select name="filters[' +  field_name + '][][value]">' + 
        '<option value="true"' + (field_value == "true" ? 'selected="selected"' : '') + '>True</option>' +
        '<option value="false"' + (field_value == "false" ? 'selected="selected"' : '') + '>False</option>' +
      '</select>';
      break;
    case 'datetime':
      var control = '<select class="switch-additionnal-fieldsets" value="' + field_operator + '" name="filters[' +  field_name + '][][operator]">' + 
        '<option value="today" data-additional-fieldset="false">Today</option>' +
        '<option value="yesterday" data-additional-fieldset="false">Yesterday</option>' +
        '<option value="this_week" data-additional-fieldset="false">This week</option>' +
        '<option value="last_week" data-additional-fieldset="false">Last week</option>' +
        '<option value="less_than" data-additional-fieldset="true">Less than ... days ago</option>' +
        '<option value="more_than" data-additional-fieldset="true">More than ... days ago</option>' +
      '</select>' +
      '<input class="additional-fieldset" style="display:none;" type="text" name="filters[' +  field_name + '][][value]" value="' + field_value + '" /> ';
      break;
    case 'enum':
      
      field_options = $j('<div/>').html(field_options).text(); // entities decode
      var control = '<select name="filters[' +  field_name + '][][value]">' + 
        field_options + 
      '</select>';
      break;
    case 'string':
      var control = '<select value="' + field_operator + '" name="filters[' +  field_name + '][][operator]">' + 
        '<option value="like" ' + (field_operator == "like" ? 'selected="selected"' : '') + '>Like</option>' +
        '<option value="starts_with" ' + (field_operator == "starts_with" ? 'selected="selected"' : '') + '>Starts with</option>' +
        '<option value="ends_with" ' + (field_operator == "ends_with" ? 'selected="selected"' : '') + '>Ends with</option>' +
        '<option value="is" ' + (field_operator == "is" ? 'selected="selected"' : '') + '>Is exactly</option>' +
      '</select>' +
      '<input type="text" name="filters[' +  field_name + '][][value]" value="' + field_value + '" /> ';
      break;
    default:
      var control = '<input type="text" name="filters[' +  field_name + '][][value]" value="' + field_value + '" /> ';
      break;
  }
  
  $j('#filters_box').append(
    '<div class="filter" style="clear:both;">' + 
    
      '<span class="delete" data-disabler-name="filters[' +  field_name + '][][disabled]" style="cursor:pointer" title="delete"> X </span>' +
      '<label>' + field_label + '</label>' + 
      control +
    '</div>'
  );
  
  $j('.switch-additionnal-fieldsets').live('change', function() {
    var selected_option = $j(this).find('option:selected');
    if($j(selected_option).data('additional-fieldset')) {
      $j(this).siblings('.additional-fieldset').val('');
      $j(this).siblings('.additional-fieldset').show();
    } else {
      $j(this).siblings('.additional-fieldset').hide();
    }
  });
  

}
