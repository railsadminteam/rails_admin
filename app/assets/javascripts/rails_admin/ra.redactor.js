(function() {
  $(document).on('rails_admin.dom_ready', function() {
    var $redactorTextareas = $('textarea[data-richtext=redactor]');

    if($redactorTextareas.length > 0) {
      var jsPath = $redactorTextareas.data('js-path');
      var cssPath = $redactorTextareas.data('css-path');

      if($('link[href="' + cssPath + '"]').length === 0) {
        $('head').append('<link href="' + cssPath + '" rel="stylesheet" media="all" type="text/css">');
      }

      if($.fn.redactor) {
        onRedactorReady();
      }else{
        $.getScript(jsPath, onRedactorReady);
      }
    }
  });

  var onRedactorReady = function() {
    $('textarea[data-richtext=redactor]').each(function() {
      var $redactorTextarea = $(this);
      var options = null;

      try {
        options = JSON.parse($redactorTextarea.data('options'));
      }catch(e){}

      $redactorTextarea.redactor(options);
    });
  };
})();