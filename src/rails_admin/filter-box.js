import jQuery from "jquery";
import I18n from "./i18n";
import flatpickr from "flatpickr";

(function ($) {
  var filters;

  $.filters = filters = {
    append: function (options) {
      options = options || {};
      var field_label = options["label"];
      var field_name = options["name"];
      var field_type = options["type"];
      var field_value = options["value"];
      var field_operator = options["operator"];
      var select_options = options["select_options"];
      var required = options["required"];
      var index = options["index"];
      var value_name = "f[" + field_name + "][" + index + "][v]";
      var operator_name = "f[" + field_name + "][" + index + "][o]";
      var control = null;
      var additional_control = null;

      switch (field_type) {
        case "boolean":
          control = $('<select class="form-control form-control-sm"></select>')
            .prop("name", value_name)
            .append('<option value="_discard">...</option>')
            .append(
              $('<option value="true"></option>')
                .prop("selected", field_value == "true")
                .text(I18n.t("true"))
            )
            .append(
              $('<option value="false"></option>')
                .prop("selected", field_value == "false")
                .text(I18n.t("false"))
            );
          if (!required) {
            control.append([
              '<option disabled="disabled">---------</option>',
              $('<option value="_present"></option>')
                .prop("selected", field_value == "_present")
                .text(I18n.t("is_present")),
              $('<option value="_blank"></option>')
                .prop("selected", field_value == "_blank")
                .text(I18n.t("is_blank")),
            ]);
          }
          break;
        case "date":
        case "datetime":
        case "timestamp":
        case "time":
          control =
            control ||
            $(
              '<select class="switch-additional-fieldsets form-control form-control-sm"></select>'
            )
              .prop("name", operator_name)
              .append(
                $(
                  '<option data-additional-fieldset="default" value="default"></option>'
                )
                  .prop("selected", field_operator == "default")
                  .text(I18n.t(field_type == "time" ? "time" : "date"))
              )
              .append(
                $(
                  '<option data-additional-fieldset="between" value="between"></option>'
                )
                  .prop("selected", field_operator == "between")
                  .text(I18n.t("between_and_"))
              );
          if (field_type != "time") {
            control.append([
              $('<option value="today"></option>')
                .prop("selected", field_operator == "today")
                .text(I18n.t("today")),
              $('<option value="yesterday"></option>')
                .prop("selected", field_operator == "yesterday")
                .text(I18n.t("yesterday")),
              $('<option value="this_week"></option>')
                .prop("selected", field_operator == "this_week")
                .text(I18n.t("this_week")),
              $('<option value="last_week"></option>')
                .prop("selected", field_operator == "last_week")
                .text(I18n.t("last_week")),
            ]);
          }
          if (!required) {
            control.append([
              '<option disabled="disabled">---------</option>',
              $('<option value="_not_null"></option>')
                .prop("selected", field_operator == "_not_null")
                .text(I18n.t("is_present")),
              $('<option value="_null"></option>')
                .prop("selected", field_operator == "_null")
                .text(I18n.t("is_blank")),
            ]);
          }
          additional_control = $.map(
            [undefined, "-∞", "∞"],
            function (placeholder, index) {
              var visible =
                index == 0
                  ? !field_operator || field_operator == "default"
                  : field_operator == "between";
              return $('<span class="additional-fieldset"></span>')
                .addClass(index == 0 ? "default" : "between")
                .css("display", visible ? "inline-block" : "none")
                .html(
                  $(
                    '<input class="input-sm form-control form-control-sm" type="text" />'
                  )
                    .addClass(field_type == "date" ? "date" : "datetime")
                    .prop("name", value_name + "[]")
                    .prop("value", field_value[index] || "")
                    .prop(
                      "size",
                      field_type == "date" || field_type == "time" ? 20 : 25
                    )
                    .prop("placeholder", placeholder)
                );
            }
          );
          break;
        case "enum":
          var multiple_values = field_value instanceof Array ? true : false;
          control = $(
            '<select class="select-single form-control form-control-sm"></select>'
          )
            .css("display", multiple_values ? "none" : "inline-block")
            .prop("name", multiple_values ? undefined : value_name)
            .data("name", value_name)
            .append('<option value="_discard">...</option>')
            .append(
              required
                ? []
                : [
                    $('<option value="_present"></option>')
                      .prop("selected", field_value == "_present")
                      .text(I18n.t("is_present")),
                    $('<option value="_blank"></option>')
                      .prop("selected", field_value == "_blank")
                      .text(I18n.t("is_blank")),
                    '<option disabled="disabled">---------</option>',
                  ]
            )
            .append(select_options)
            .add(
              $(
                '<select multiple="multiple" class="select-multiple form-control form-control-sm"></select>'
              )
                .css("display", multiple_values ? "inline-block" : "none")
                .prop("name", multiple_values ? value_name + "[]" : undefined)
                .data("name", value_name + "[]")
                .append(select_options)
            )
            .add(
              $('<a href="#" class="switch-select"></a>').append(
                $("<i></i>").addClass(
                  "fas fa-" + (multiple_values ? "minus" : "plus")
                )
              )
            );
          break;
        case "citext":
        case "string":
        case "text":
        case "belongs_to_association":
          control = $(
            '<select class="switch-additional-fieldsets form-control form-control-sm"></select>'
          )
            .prop("value", field_operator)
            .prop("name", operator_name)
            .append('<option value="_discard">...</option>')
            .append(
              $(
                '<option data-additional-fieldset="additional-fieldset" value="like"></option>'
              )
                .prop("selected", field_operator == "like")
                .text(I18n.t("contains"))
            )
            .append(
              $(
                '<option data-additional-fieldset="additional-fieldset" value="not_like"></option>'
              )
                .prop("selected", field_operator == "not_like")
                .text(I18n.t("does_not_contain"))
            )
            .append(
              $(
                '<option data-additional-fieldset="additional-fieldset" value="is"></option>'
              )
                .prop("selected", field_operator == "is")
                .text(I18n.t("is_exactly"))
            )
            .append(
              $(
                '<option data-additional-fieldset="additional-fieldset" value="starts_with"></option>'
              )
                .prop("selected", field_operator == "starts_with")
                .text(I18n.t("starts_with"))
            )
            .append(
              $(
                '<option data-additional-fieldset="additional-fieldset" value="ends_with"></option>'
              )
                .prop("selected", field_operator == "ends_with")
                .text(I18n.t("ends_with"))
            );
          if (!required) {
            control.append([
              '<option disabled="disabled">---------</option>',
              $('<option value="_present"></option>')
                .prop("selected", field_operator == "_present")
                .text(I18n.t("is_present")),
              $('<option value="_blank"></option>')
                .prop("selected", field_operator == "_blank")
                .text(I18n.t("is_blank")),
            ]);
          }
          additional_control = $(
            '<input class="additional-fieldset form-control form-control-sm" type="text" />'
          )
            .css(
              "display",
              field_operator == "_present" || field_operator == "_blank"
                ? "none"
                : "inline-block"
            )
            .prop("name", value_name)
            .prop("value", field_value);
          break;
        case "integer":
        case "decimal":
        case "float":
          control = $(
            '<select class="switch-additional-fieldsets form-control form-control-sm"></select>'
          )
            .prop("name", operator_name)
            .append(
              $(
                '<option data-additional-fieldset="default" value="default"></option>'
              )
                .prop("selected", field_operator == "default")
                .text(I18n.t("number"))
            )
            .append(
              $(
                '<option data-additional-fieldset="between" value="between"></option>'
              )
                .prop("selected", field_operator == "between")
                .text(I18n.t("between_and_"))
            );
          if (!required) {
            control.append([
              '<option disabled="disabled">---------</option>',
              $('<option value="_not_null"></option>')
                .prop("selected", field_operator == "_not_null")
                .text(I18n.t("is_present")),
              $('<option value="_null"></option>')
                .prop("selected", field_operator == "_null")
                .text(I18n.t("is_blank")),
            ]);
          }
          additional_control = $(
            '<input class="additional-fieldset default form-control form-control-sm" type="text" />'
          )
            .css(
              "display",
              !field_operator || field_operator == "default"
                ? "inline-block"
                : "none"
            )
            .prop("type", field_type)
            .prop("name", value_name + "[]")
            .prop("value", field_value[0] || "")
            .add(
              $(
                '<input placeholder="-∞" class="additional-fieldset between form-control form-control-sm" />'
              )
                .css(
                  "display",
                  field_operator == "between" ? "inline-block" : "none"
                )
                .prop("type", field_type)
                .prop("name", value_name + "[]")
                .prop("value", field_value[1] || "")
            )
            .add(
              $(
                '<input placeholder="∞" class="additional-fieldset between form-control form-control-sm" />'
              )
                .css(
                  "display",
                  field_operator == "between" ? "inline-block" : "none"
                )
                .prop("type", field_type)
                .prop("name", value_name + "[]")
                .prop("value", field_value[2] || "")
            );
          break;
        default:
          control = $(
            '<input type="text" class="form-control form-control-sm" />'
          )
            .prop("name", value_name)
            .prop("value", field_value);
          break;
      }

      var filterContainerId = field_name + "-" + index + "-filter-container";
      $("p#" + filterContainerId).remove();

      var $content = $("<div>")
        .attr("id", filterContainerId)
        .addClass("filter d-inline-block my-1")
        .append(
          $(
            '<button type="button" class="btn btn-info btn-sm delete"></button>'
          )
            .append('<i class="fas fa-trash"></i>')
            .append(document.createTextNode(field_label))
        )
        .append("&nbsp;")
        .append(control)
        .append("&nbsp;")
        .append(additional_control);

      $("#filters_box").append($content);

      $content.find(".date, .datetime").each(function () {
        flatpickr(
          this,
          $.extend(
            {
              dateFormat: "Y-m-dTH:i:S",
              altInput: true,
              locale: I18n.locale,
            },
            options["datetimepicker_options"]
          )
        );
      });

      $("hr.filters_box:hidden").show("slow");
    },
  };

  $(document).on("click", "#filters a", function (e) {
    e.preventDefault();
    $.filters.append({
      label: $(this).data("field-label"),
      name: $(this).data("field-name"),
      type: $(this).data("field-type"),
      value: $(this).data("field-value"),
      operator: $(this).data("field-operator"),
      select_options: $(this).data("field-options"),
      required: $(this).data("field-required"),
      index: $.now().toString().slice(6, 11),
      datetimepicker_options: $(this).data("field-datetimepicker-options"),
    });
  });

  $(document).on("click", "#filters_box .delete", function (e) {
    e.preventDefault();
    var form = $(this).parents("form");
    $(this).parents(".filter").remove();
    !$("#filters_box").children().length &&
      $("hr.filters_box:visible").hide("slow");
  });

  $(document).on("click", "#filters_box .switch-select", function (e) {
    e.preventDefault();
    var selected_select = $(this).siblings("select:visible");
    var not_selected_select = $(this).siblings("select:hidden");
    not_selected_select
      .attr("name", not_selected_select.data("name"))
      .show("slow");
    selected_select.attr("name", null).hide("slow");
    $(this).find("i").toggleClass("fa-plus fa-minus");
  });

  $(document).on(
    "change",
    "#filters_box .switch-additional-fieldsets",
    function (e) {
      var selected_option = $(this).find("option:selected");
      var klass = $(selected_option).data("additional-fieldset");
      if (klass) {
        $(this)
          .siblings(".additional-fieldset:not(." + klass + ")")
          .hide("slow");
        $(this)
          .siblings("." + klass)
          .show("slow");
      } else {
        $(this).siblings(".additional-fieldset").hide("slow");
      }
    }
  );
})(jQuery);
