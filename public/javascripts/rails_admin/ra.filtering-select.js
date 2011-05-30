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
    options: {
      createQuery: function(query) {
        return { query: query };
      },
      minLength: 0,
      searchDelay: 200,
      source: null
    },

    _create: function() {
      var self = this,
        select = this.element.hide(),
        selected = select.children(":selected"),
        value = selected.val() ? selected.text() : "";

      if (!this.options.source) {
        this.options.source = select.children("option").map(function() {
          return { label: $(this).text(), value: this.value };
        }).toArray();
      }

      var input = this.input = $("<input>")
        .insertAfter(select)
        .val(value)
        .addClass("ra-filtering-select-input")
        .attr('style', select.attr('style'))
        .show()
        .autocomplete({
          delay: this.options.searchDelay,
          minLength: this.options.minLength,
          source: this._getSourceFunction(this.options.source),
          select: function(event, ui) {
            var option = $('<option value="' + ui.item.id + '" selected="selected">' + ui.item.value + '</option>');
            select.html(option);
            self._trigger("selected", event, {
              item: option
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

    _getResultSet: function(request, data, xhr) {
	    var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
			
      return $.map(data, function(el, i) {	
				// match regexp only for local requests, remote ones are already filtered, and label may not contain filtered term.
        if ((el.id || el.value) && (xhr || matcher.test(el.label))) { 
          return {
            label: el.label.replace(
              new RegExp(
                "(?![^&;]+;)(?!<[^<>]*)(" +
                $.ui.autocomplete.escapeRegex(request.term) +
                ")(?![^<>]*>)(?![^&;]+;)", "gi"
             ), "<strong>$1</strong>"),
            value: el.label,
            id: el.id || el.value
          };
        }
      });
    },

    _getSourceFunction: function(source) {

      var self = this,
          requestIndex = 0;

      if ($.isArray(source)) {

        return function(request, response) {
          response(self._getResultSet(request, source, false));
        };

      } else if (typeof source === "string") {

        return function(request, response) {

          if (this.xhr) {
            this.xhr.abort();
          }

          this.xhr = $.ajax({
            url: source,
            data: self.options.createQuery(request.term),
            dataType: "json",
            autocompleteRequest: ++requestIndex,
            success: function(data, status) {
              if (this.autocompleteRequest === requestIndex) {
                response(self._getResultSet(request, data, true));
              }
            },
            error: function() {
              if (this.autocompleteRequest === requestIndex) {
                response([]);
              }
            }
          });
        };

      } else {

        return source;
      }
    },

    destroy: function() {
      this.input.remove();
      this.button.remove();
      this.element.show();
      $.Widget.prototype.destroy.call(this);
    }
  });
})(jQuery);