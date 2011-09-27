if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

// LIST PAGE

$j("#list input.checkbox.toggle").live('click', function() {
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

$j('#list a, #list form').live('ajax:complete', function(xhr, data, status) {
  $j("#list").html(data.responseText);
});

$j('#list table th.header').live('click', function() {
  $j.ajax({
    url: $j(this).data('link'),
    success: function(data){
      $j("#list").html(data);
    }
  });
});

$j('table#history th.header').live('click', function() {
  window.location = $j(this).data('link');
});


$j(document).ready(function() {
  $j(".alert-message").alert();
  $j("[rel=twipsy]").twipsy();
});