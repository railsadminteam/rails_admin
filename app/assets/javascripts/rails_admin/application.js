if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

// accordeon
$j("#nav .more a").live('click', function() {
  $j(this).siblings('ul').toggle('slide');
});

$j("table.table tr.link").live('click', function(e) {
  // trs and tds are things that we want to link to the edit page
  // if the click's target is a button for instance, we don't want to move the user.
  if ($j(e.target).is('tr') || $j(e.target).is('td') || $j(e.target).is('div.bar')) {
    window.location.href = $j(this).attr("data-link");
  };
});

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
