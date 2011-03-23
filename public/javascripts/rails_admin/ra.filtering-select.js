/*
 * RailsAdmin filtering select @VERSION
 *
 * Based on the combobox example from jQuery UI documentation
 * http://jqueryui.com/demos/autocomplete/#combobox
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.autocomplete.js
 */
(function($) {
  $.widget("ra.filteringSelect", {
    _create: function() {
      var self = this,
        select = this.element.hide(),
        selected = select.children(":selected"),
        value = selected.val() ? selected.text() : "";
      var input = this.input = $("<input>")
        .insertAfter(select)
        .val(value)
        .addClass("ra-filtering-select-input")
        .autocomplete({
          delay: 0,
          minLength: 0,
          source: function(request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response(select.children("option").map(function() {
              var text = $(this).text();
              if (this.value && (!request.term || matcher.test(text)))
                return {
                  label: text.replace(
                    new RegExp(
                      "(?![^&;]+;)(?!<[^<>]*)(" +
                      $.ui.autocomplete.escapeRegex(request.term) +
                      ")(?![^<>]*>)(?![^&;]+;)", "gi"
                   ), "<strong>$1</strong>"),
                  value: text,
                  option: this
                };
            }));
          },
          select: function(event, ui) {
            ui.item.option.selected = true;
            self._trigger("selected", event, {
              item: ui.item.option
            });
          },
          change: function(event, ui) {
            if (!ui.item) {
              var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$", "i"),
                valid = false;
              select.children("option").each(function() {
                if ($(this).text().match(matcher)) {
                  this.selected = valid = true;
                  return false;
                }
              });
              if (!valid) {
                // remove invalid value, as it didn't match anything
                $(this).val("");
                select.val("");
                input.data("autocomplete").term = "";
                return false;
              }
            }
          }
        })
        .addClass("ui-widget ui-widget-content ui-corner-left");

      input.data("autocomplete")._renderItem = function(ul, item) {
        return $("<li></li>")
          .data("item.autocomplete", item)
          .append("<a>" + item.label + "</a>")
          .appendTo(ul);
      };

      this.button = $("<button type='button'>&nbsp;</button>")
        .attr("tabIndex", -1)
        .attr("title", "Show All Items")
        .insertAfter(input)
        .button({
          icons: {
            primary: "ui-icon-triangle-1-s"
          },
          text: false
        })
        .removeClass("ui-corner-all")
        .addClass("ra-filtering-select-button ui-corner-right")
        .click(function() {
          // close if already visible
          if (input.autocomplete("widget").is(":visible")) {
            input.autocomplete("close");
            return;
          }

          // pass empty string as value to search for, displaying all results
          input.autocomplete("search", "");
          input.focus();
        });
    },

    destroy: function() {
      this.input.remove();
      this.button.remove();
      this.element.show();
      $.Widget.prototype.destroy.call(this);
    }
  });
})(jQuery);