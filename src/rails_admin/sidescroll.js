"use strict";

{
  document.addEventListener("rails_admin.dom_ready", function() {
    var scroller = document.getElementById("sidescroll");
    if (!scroller) {
      return;
    }

    scroller.querySelectorAll("tr").forEach(function(tr, index) {
      var firstPosition;
      tr.querySelectorAll("th.sticky, td.sticky").forEach(function(td, idx) {
        if (idx === 0) {
          firstPosition = td.offsetLeft;
        }
        td.style.left = (td.offsetLeft - firstPosition) + "px";
      });
    });
  });
}
