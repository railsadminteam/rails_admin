window.domReadyTriggered = [];

document.addEventListener("rails_admin.dom_ready", function () {
  window.domReadyTriggered.push("plainjs/dot");
});

$(document).on("rails_admin.dom_ready", function () {
  window.domReadyTriggered.push("jquery/dot");
});
