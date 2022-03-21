import jQuery from "jquery";
import "jquery-ui/ui/effect";
import I18n from "./i18n";

(function ($) {
  $(document).on("click", "#list input.toggle", function () {
    $("#list [name='bulk_ids[]']").prop("checked", $(this).is(":checked"));
  });

  $(document).on("click", "[data-bs-target]", function () {
    if (!$(this).hasClass("disabled")) {
      if ($(this).has("i.fa-chevron-down").length) {
        $(this)
          .removeClass("active")
          .children("i")
          .toggleClass("fa-chevron-down fa-chevron-right");
        $($(this).data("target")).filter(":visible").hide("slow");
      } else {
        if ($(this).has("i.fa-chevron-right").length) {
          $(this)
            .addClass("active")
            .children("i")
            .toggleClass("fa-chevron-down fa-chevron-right");
          $($(this).data("target")).filter(":hidden").show("slow");
        }
      }
    }
  });

  $(document).on("click", "form legend", function () {
    if ($(this).has("i.fa-chevron-down").length) {
      $(this).siblings(".control-group:visible").hide("slow");
      $(this).children("i").toggleClass("fa-chevron-down fa-chevron-right");
    } else {
      if ($(this).has("i.fa-chevron-right").length) {
        $(this).siblings(".control-group:hidden").show("slow");
        $(this).children("i").toggleClass("fa-chevron-down fa-chevron-right");
      }
    }
  });

  $(document).on(
    "click",
    "form .tab-content .tab-pane a.remove_nested_one_fields",
    function () {
      $(this)
        .children('input[type="hidden"]')
        .val($(this).hasClass("active"))
        .siblings("i")
        .toggleClass("fa-check fa-trash");
    }
  );

  document.addEventListener("turbo:load", function () {
    I18n.init($("html").attr("lang"), $("#admin-js").data("i18nOptions"));

    const event = new CustomEvent("rails_admin.dom_ready");
    document.dispatchEvent(event);
  });

  document.addEventListener("rails_admin.dom_ready", function () {
    $(".nav.nav-pills li.active").removeClass("active");
    $(
      '.nav.nav-pills li[data-model="' + $(".page-header").data("model") + '"]'
    ).addClass("active");
    $(".animate-width-to").each(function () {
      var length, width;
      length = $(this).data("animate-length");
      width = $(this).data("animate-width-to");
      $(this).animate(
        {
          width: width,
        },
        length,
        "easeOutQuad"
      );
    });
    $("form.main legend")
      .has("i.fa-chevron-right")
      .each(function () {
        $(this).siblings(".control-group").hide();
      });
    $('button[name][type="submit"]')
      .attr("type", "button")
      .on("click", function () {
        var form = $(this).closest("form");
        form.append(
          $("<input />")
            .attr("type", "hidden")
            .attr("name", $(this).attr("name"))
            .attr("value", true)
        );
        if ($(this).is("[formnovalidate]")) {
          form.attr("novalidate", true);
        }
        form.trigger("submit");
      });
    $.each($("#filters_box").data("options"), function () {
      $.filters.append(this);
    });
    // Workaround for https://github.com/heartcombo/devise/issues/5458
    $("a[data-method]").on("click", function (event) {
      window.Turbo.session.drive = false;
    });
  });

  $(document).on("click", ".bulk-link", function (event) {
    event.preventDefault();
    $("#bulk_action").val($(this).data("action"));
    $("#bulk_form").submit();
  });

  $(document).on("click", "#remove_filter", function (event) {
    event.preventDefault();
    $("#filters_box").html("");
    $("hr.filters_box").hide();
    $(this).siblings("input[type='search']").val("");
    $(this).parents("form").submit();
  });

  $(document).on("click", "th.header", function (event) {
    event.preventDefault();
    window.Turbo.visit($(this).data("href"));
  });

  $(document).on(
    "click",
    "#fields_to_export label input#check_all",
    function () {
      var elems;
      elems = $("#fields_to_export label input");
      if ($("#fields_to_export label input#check_all").is(":checked")) {
        $(elems).prop("checked", true);
      } else {
        $(elems).prop("checked", false);
      }
    }
  );

  $(document).on("click", "#fields_to_export .reverse-selection", function () {
    $(this).closest(".control-group").find(".controls").find("input").click();
  });
})(jQuery);
