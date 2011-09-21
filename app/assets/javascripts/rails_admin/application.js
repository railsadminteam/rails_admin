if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

// On the list page, the checkbox in th table's header toggles all the checkboxes underneath it.
$j("table.table input.checkbox.toggle").live('click', function() {
  var checked_status = $j(this).is(":checked");
  $j("td.action.select input.checkbox[name='bulk_ids[]']").each(function() {
    $j(this).attr('checked', checked_status);

    if (checked_status) {
      $j(this).parent().addClass("checked");
    } else {
      $j(this).parent().removeClass("checked");
    }
  });
});


$j(".alert-message").alert();