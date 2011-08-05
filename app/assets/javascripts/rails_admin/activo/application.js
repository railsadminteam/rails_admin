(function($) {
  $(document).ready(function()
  {
    // Tooltips (http://onehackoranother.com/projects/jquery/tipsy)
    $('img').each( function() {
      if ($(this).get(0).title != '') {
        $(this).tipsy();
      }
    });
  });
})(jQuery)
