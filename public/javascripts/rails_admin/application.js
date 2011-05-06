if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

$j(document).ready(function($){
  $(".ra-button").not(".ui-button").button({});
});