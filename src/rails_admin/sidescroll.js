"use strict";

{
  document.addEventListener("rails_admin.dom_ready", () => {
    const scroller = document.getElementById("sidescroll");
    if (!scroller) {
      return;
    }

    scroller.querySelectorAll("tr").forEach((tr, index) => {
      let firstPosition;
      tr.querySelectorAll("th.sticky, td.sticky").forEach((td, idx) => {
        if (idx === 0) {
          firstPosition = td.offsetLeft;
        }
        td.style.left = `${td.offsetLeft - firstPosition}px`;
      });
    });
  });
}
