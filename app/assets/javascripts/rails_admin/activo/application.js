(function($) {
  $(document).ready(function()
  {
    // Tooltips (http://onehackoranother.com/projects/jquery/tipsy)
    $('img').each( function() {
      if ($(this).get(0).title != '') {
        $(this).tipsy();
      }
    });

    // Scroll effect for anchors (http://flesler.blogspot.com/2007/10/jqueryscrollto.html)
    $('a').click(function() {
       if ($(this).attr('class') == 'anchor') {
         $.scrollTo(this.hash, 500);
         $(this.hash).find('span.message').text(this.href);
         return false;
       }
    });
  });
})(jQuery)
