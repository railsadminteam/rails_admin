"use strict";

{
  document.addEventListener("rails_admin.dom_ready", () => {
    const listForm = document.getElementById("bulk_form");
    if (!listForm || !listForm.classList.contains("ra-sidescroll")) {
      return;
    }

    const frozenColumns = Number(listForm.dataset.raSidescroll);
    listForm.querySelectorAll("tr").forEach((tr, index) => {
      let firstPosition;
      Array.from(tr.children)
        .slice(0, frozenColumns)
        .forEach((td, idx) => {
          td.classList.add("ra-sidescroll-frozen");
          if (idx === frozenColumns - 1) {
            td.classList.add("last-of-frozen");
          }
          if (idx === 0) {
            firstPosition = td.offsetLeft;
          }
          td.style.left = `${td.offsetLeft - firstPosition}px`;
        });
    });
  });
}
