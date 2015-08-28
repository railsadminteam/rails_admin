$(function() {
  var $redactorTextareas = $('textarea[data-richtext=redactor]');

  if($redactorTextareas.length > 0) {
    var jsPath = $redactorTextareas.data('js-path');
    var cssPath = $redactorTextareas.data('css-path');

    $('head').append('<link href="' + cssPath + '" rel="stylesheet" media="all" type="text/css">');

    $.getScript(jsPath, function() {
      $redactorTextareas.each(function() {
        var $readactorTextarea = $(this);
        var options = null;

        try {
          options = JSON.parse($readactorTextarea.data('options'));
        }catch(e){}

        $readactorTextarea.redactor(options);
      });
    });
  }
});