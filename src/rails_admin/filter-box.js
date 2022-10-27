import jQuery from "jquery";
import I18n from "./i18n";
import flatpickr from "flatpickr";

(function ($) {
  var filters;

  $.filters = filters = {
    append: function (options) {
      var field_label = options["label"];
      var field_name = options["name"];
      var field_type = options["type"];
      var field_value = options["value"] || "";
      var field_operator = options["operator"];
      var operators = options["operators"];
      var index = options["index"];
      var value_name = "f[" + field_name + "][" + index + "][v]";
      var operator_name = "f[" + field_name + "][" + index + "][o]";
      var control = null;
      var additional_control = null;

      if (operators.length > 0) {
        control = $(
          '<select class="form-control form-select form-select-sm"></select>'
        ).prop("name", operator_name);

        operators.forEach((operator) => {
          var element = this.build_operator(operator, options);
          if (!element) {
            return;
          }
          if (element.prop("value") === field_operator) {
            element.prop("selected", true);
          }
          control.append(element);
        });

        if (control.find("[data-additional-fieldset]").length > 0) {
          control.addClass("switch-additional-fieldsets");
        }
      }

      switch (field_type) {
        case "boolean":
          control &&
            control
              .prop("name", value_name)
              .find("option")
              .each(function () {
                if ($(this).attr("value") === field_value)
                  $(this).attr("selected", true);
              });
          break;
        case "date":
        case "datetime":
        case "timestamp":
        case "time":
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
          if (control) {
            var multiple = field_value instanceof Array;
            control = control
              .prop("name", multiple ? value_name + "[]" : value_name)
              .prop("multiple", multiple)
              .add(
                $('<a href="#" class="switch-select"></a>').append(
                  $("<i></i>").addClass(
                    "fas fa-" + (multiple ? "minus" : "plus")
                  )
                )
              );
            control.find("option").each(function () {
              const value = $(this).attr("value");
              if (
                multiple ? field_value.includes(value) : value === field_value
              )
                $(this).attr("selected", true);
            });
            if (multiple)
              control.find("option[value^=_],option[disabled]").hide();
          }
          break;
        case "citext":
        case "string":
        case "text":
        case "belongs_to_association":
        case "has_one_association":
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
    build_operator: function (operator, options) {
      if (operator instanceof Object) {
        var element = $("<option></option>");
        element.text(operator.label);
        delete operator.label;
        for (const key in operator) {
          element.attr(key, operator[key]);
        }
        return element;
      }
      switch (operator) {
        case "_discard":
          return $('<option value="_discard">...</option>');
        case "_separator":
          return $('<option disabled="disabled">---------</option>');
        case "_present":
          return $('<option value="_present"></option>').text(
            I18n.t("is_present")
          );
        case "_blank":
          return $('<option value="_blank"></option>').text(I18n.t("is_blank"));
        case "_not_null":
          return $('<option value="_not_null"></option>').text(
            I18n.t("is_present")
          );
        case "_null":
          return $('<option value="_null"></option>').text(I18n.t("is_blank"));

        case "true":
          return $('<option value="true"></option>').text(I18n.t("true"));
        case "false":
          return $('<option value="false"></option>').text(I18n.t("false"));

        case "today":
          return $('<option value="today"></option>').text(I18n.t("today"));
        case "yesterday":
          return $('<option value="yesterday"></option>').text(
            I18n.t("yesterday")
          );
        case "this_week":
          return $('<option value="this_week"></option>').text(
            I18n.t("this_week")
          );
        case "last_week":
          return $('<option value="last_week"></option>').text(
            I18n.t("last_week")
          );

        case "like":
          return $(
            '<option data-additional-fieldset="additional-fieldset" value="like"></option>'
          ).text(I18n.t("contains"));
        case "not_like":
          return $(
            '<option data-additional-fieldset="additional-fieldset" value="not_like"></option>'
          ).text(I18n.t("does_not_contain"));
        case "is":
          return $(
            '<option data-additional-fieldset="additional-fieldset" value="is"></option>'
          ).text(I18n.t("is_exactly"));
        case "starts_with":
          return $(
            '<option data-additional-fieldset="additional-fieldset" value="starts_with"></option>'
          ).text(I18n.t("starts_with"));
        case "ends_with":
          return $(
            '<option data-additional-fieldset="additional-fieldset" value="ends_with"></option>'
          ).text(I18n.t("ends_with"));

        case "default":
          var label;
          switch (options.type) {
            case "date":
            case "datetime":
            case "timestamp":
              label = I18n.t("date");
              break;
            case "time":
              label = I18n.t("time");
              break;
            case "integer":
            case "decimal":
            case "float":
              label = I18n.t("number");
              break;
          }
          return $(
            '<option data-additional-fieldset="default" value="default"></option>'
          ).text(label);
        case "between":
          return $(
            '<option data-additional-fieldset="between" value="between"></option>'
          ).text(I18n.t("between_and_"));

        default:
          return null;
      }
    },
  };

  $(document).on("click", "#filters a", function (e) {
    e.preventDefault();
    $.filters.append(
      $.extend(
        { index: $.now().toString().slice(6, 11) },
        $(this).data("options")
      )
    );
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
    var select = $(this).siblings("select");
    select.attr("multiple", !select.attr("multiple"));
    select.attr(
      "name",
      select.attr("multiple")
        ? select.attr("name") + "[]"
        : select.attr("name").replace(/\[\]$/, "")
    );
    select.find("option[value^=_],option[disabled]").toggle();
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
