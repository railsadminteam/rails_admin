$j(document).ready(function($){
  
  $("#filter_select").bind('change', function() {
    
    var option = $(this).find('option:selected')
    $(this).val(''); // reset select
    append_filter(option.data('field-label'), option.data('field-name'), option.data('field-type'), option.data('field-value'), option.data('field-operator'), option.data('field-options'));
  });
  
  $('#filters_box .delete').live('click', function() {
    $(this).parents('.filter').hide();
    
    $(this).append('<input type="hidden" name="' + $(this).data('disabler-name') + '" value="true" />')
  });
});


var append_filter = function(field_label, field_name, field_type, field_value, field_operator, field_options) {
  console.log(field_label, field_name, field_type, field_value, field_operator, field_options)
  
  switch(field_type) {
    case 'boolean': 
      var control = '<select name="filters[' +  field_name + '][][value]">' + 
        '<option value="true"' + (field_value == "true" ? 'selected="selected"' : '') + '>True</option>' +
        '<option value="false"' + (field_value == "false" ? 'selected="selected"' : '') + '>False</option>' +
      '</select>';
      break;
    case 'datetime':
      var control = '<select value="' + field_operator + '" name="filters[' +  field_name + '][][operator]">' + 
        '<option value="after" ' + (field_operator == "after" ? 'selected="selected"' : '') + '>After</option>' +
        '<option value="before" ' + (field_operator == "before" ? 'selected="selected"' : '') + '>Before</option>' +
      '</select>' +
      '<input type="text" name="filters[' +  field_name + '][][value]" value="' + field_value + '" /> ';
      break;
    case 'enum':
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
      control +
      field_label + 
    '</div>'
  );
}
