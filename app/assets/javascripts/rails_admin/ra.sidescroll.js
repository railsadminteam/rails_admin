(function($) {
  function setFrozenColPositions() {
    var $listForm, frozenColumns;

    $listForm = $('#bulk_form');
    if (!$listForm.is('.ra-sidescroll')) {
      return;
    }
    frozenColumns = $listForm.data('ra-sidescroll');

    $listForm.find('table tr').each(function(index, tr) {
      var firstPosition  = 0;

      $(tr).children().slice(0, frozenColumns).each(function(idx, td) {
        var tdLeft;
        $(td).addClass('ra-sidescroll-frozen');
        if (idx === frozenColumns - 1) {
          $(td).addClass('last-of-frozen');
        }
        tdLeft = $(td).position().left;
        if (idx === 0) {
          firstPosition = tdLeft;
        }
        td.style.left = (tdLeft - firstPosition) + "px";
      });
    });
  };

  $(window).on('load', setFrozenColPositions);
  $(document).on('rails_admin.dom_ready', setFrozenColPositions);
})(jQuery);
