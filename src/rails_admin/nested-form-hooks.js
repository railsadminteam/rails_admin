import jQuery from "jquery";
import * as bootstrap from "bootstrap/dist/js/bootstrap.esm";

(function ($) {
  $(document).ready(function () {
    return (window.nestedFormEvents.insertFields = function (
      content,
      assoc,
      link
    ) {
      var tab_content;
      tab_content = $(link).closest(".controls").siblings(".tab-content");
      tab_content.append(content);
      return tab_content.children().last();
    });
  });

  $(document).on("nested:fieldAdded", "form", function (content) {
    var controls, field, nav, new_tab, one_to_one, parent_group, toggler;
    field = content.field
      .addClass("tab-pane")
      .attr("id", "unique-id-" + new Date().getTime());
    new_tab = $("<li></li>")
      .append(
        $("<a></a>")
          .addClass("nav-link")
          .attr("data-bs-toggle", "tab")
          .attr("href", "#" + field.attr("id"))
          .text(field.children(".object-infos").data("object-label"))
      )
      .addClass("nav-item");
    parent_group = field.closest(".control-group");
    controls = parent_group.children(".controls");
    one_to_one = controls.data("nestedone") !== void 0;
    nav = controls.children(".nav");
    content = parent_group.children(".tab-content");
    toggler = controls.find(".toggler");
    nav.append(new_tab);

    const event = new CustomEvent("rails_admin.dom_ready", { detail: field });
    document.dispatchEvent(event);

    new_tab.children("a").each(function (index, element) {
      bootstrap.Tab.getOrCreateInstance(element).show();
    });
    if (!one_to_one) {
      nav.filter(":hidden").show("slow");
    }
    content.filter(":hidden").show("slow");
    toggler
      .addClass("active")
      .removeClass("disabled")
      .children("i")
      .addClass("fa-chevron-down")
      .removeClass("fa-chevron-right");
    if (one_to_one) {
      controls
        .find(".add_nested_fields")
        .removeClass("add_nested_fields")
        .text(field.children(".object-infos").data("object-label"));
    }
  });

  $(document).on("nested:fieldRemoved", "form", function (content) {
    var add_button,
      controls,
      current_li,
      field,
      nav,
      one_to_one,
      parent_group,
      toggler;
    field = content.field;
    nav = field
      .closest(".control-group")
      .children(".controls")
      .children(".nav");
    current_li = nav.children("li").has('a[href="#' + field.attr("id") + '"]');
    parent_group = field.closest(".control-group");
    controls = parent_group.children(".controls");
    one_to_one = controls.data("nestedone") !== void 0;
    toggler = controls.find(".toggler");
    (current_li.next().length ? current_li.next() : current_li.prev())
      .children("a:first")
      .each(function (index, element) {
        bootstrap.Tab.getOrCreateInstance(element).show();
      });
    current_li.remove();
    if (nav.children().length === 0) {
      nav.filter(":visible").hide("slow");
      toggler
        .removeClass("active")
        .addClass("disabled")
        .children("i")
        .removeClass("fa-chevron-down")
        .addClass("fa-chevron-right");
    }
    if (one_to_one) {
      add_button = toggler.next();
      add_button
        .addClass("add_nested_fields")
        .html(add_button.data("add-label"));
    }
    field.find("[required]").each(function () {
      $(this).prop("required", false);
    });
  });
})(jQuery);
