import "rails_admin/src/rails_admin/base";
import "flatpickr/dist/l10n/fr.js";
import "trix";
import "@rails/actiontext";
import * as ActiveStorage from "@rails/activestorage";
ActiveStorage.start();

window.domReadyTriggered = [];

document.addEventListener("rails_admin.dom_ready", function () {
  window.domReadyTriggered.push("plainjs/dot");
});

$(document).on("rails_admin.dom_ready", function () {
  window.domReadyTriggered.push("jquery/dot");
});
