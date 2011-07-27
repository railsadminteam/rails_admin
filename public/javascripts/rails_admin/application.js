if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

$j(document).ready(function($){
  // accordeon
  $("#nav .more a").live('click', function() {
    $(this).siblings('ul').toggle('slide');
  });
  
  $("table.table tr.link").live('click', function(e) {
    // trs and tds are things that we want to link to the edit page
    // if the click's target is a button for instance, we don't want to move the user.
    if ($(e.target).is('tr') || $(e.target).is('td') || $(e.target).is('div.bar')) {
      window.location.href = $(this).attr("data-link");
    };
  });

  // On the list page, the checkbox in th table's header toggles all the checkboxes underneath it.
  $("table.table input.checkbox.toggle").live('click', function() {
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
