(function($) {
  $(document).ready(function()
  {
    // jQuery uniform controls (http://pixelmatrixdesign.com/uniform)
    $("input:checkbox, input:radio, input:file").uniform();
    // consider enabling uniform for non filtering select elements:
    $("select.uniform").uniform();
    
    // jQuery datepicker for formtastic (http://gist.github.com/271377)
    $('input.ui-datepicker').datepicker({ dateFormat: 'dd-mm-yy' });

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
