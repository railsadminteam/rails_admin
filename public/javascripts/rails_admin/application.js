if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

$j(document).ready(function($){
  $(".ra-button").not(".ui-button").button({});
  
  // On the list page, the checkbox in th table's header toggles all the checkboxes underneath it.
  $("table.table input.checkbox.toggle").click(function() {
    var checked_status = $(this).is(":checked");
    $("td.action.select input.checkbox[name='bulk_ids[]']").each(function() {
      $(this).attr('checked', checked_status);
      
      if (checked_status) {
        $(this).parent().addClass("checked");
      } else {
        $(this).parent().removeClass("checked");
      }
      
    });
  });
});