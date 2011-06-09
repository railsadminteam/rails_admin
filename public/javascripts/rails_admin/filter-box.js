$j(document).ready(function($){
  
  $("#filter_select").bind('change', function() {
    var field_name = $(this).val();
    var field_label = $(this).find('option:selected').text();
    $(this).val(''); // reset select
    append_filter(field_label, field_name, "");
  });
  
  $('#filters_box .delete').live('click', function() {
    $(this).parents('.filter').remove();
  });
});


var append_filter = function(field_label, field_name, field_value) {
  $j('#filters_box').append(
    '<div class="filter" style="clear:both;">' + 
      field_label + ': ' + 
      '<input type="text" name="filters[' +  field_name + '][][value]" value="' + field_value + '">' + 
      '<span class="delete" style="cursor:pointer" title="delete"> X </span>' + 
    '</div>'
  );
}
