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
      remote_source: null,
      source: null,
      xhr: false
    },

    _create: function() {
      var self = this,
        select = this.element.hide(),
        selected = select.children(":selected"),
        value = selected.val() ? selected.text() : "";

      if (this.options.xhr) {
        this.options.source = this.options.remote_source;
      } else {
        this.options.source = select.children("option").map(function() {
          return { label: $(this).text(), value: this.value };
        }).toArray();
      }
      var filtering_select = $('<div class="input-append filtering-select" style="float:left"></div>')
      var input = this.input = $('<input type="text">')
        .val(value)
        .addClass("form-control ra-filtering-select-input")
        .attr('style', select.attr('style'))
        .show()
        .autocomplete({
          delay: this.options.searchDelay,
          minLength: this.options.minLength,
          source: this._getSourceFunction(this.options.source),
          select: function(event, ui) {
            var option = $('<option></option>').attr('value', ui.item.id).attr('selected', 'selected').text(ui.item.value);
            select.html(option);
            select.trigger("change", ui.item.id);
            self._trigger("selected", event, {
              item: option
            });
            $(self.element.parents('.controls')[0]).find('.update').removeClass('disabled');
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
              if (!valid || $(this).val() == '') {
                // remove invalid value, as it didn't match anything
                $(this).val(null);
                select.html($('<option value="" selected="selected"></option>'));
                input.data("ui-autocomplete").term = "";
                $(self.element.parents('.controls')[0]).find('.update').addClass('disabled');
                return false;
              }

            }
          }
        })
        .keyup(function() {
          /* Clear select options and trigger change if selected item is deleted */
          if ($(this).val().length == 0) {
            select.html($('<option value="" selected="selected"></option>'));
            select.trigger("change");
          }
        })

      if(select.attr('placeholder'))
        input.attr('placeholder', select.attr('placeholder'))

      input.data("ui-autocomplete")._renderItem = function(ul, item) {
        return $("<li></li>")
          .data("ui-autocomplete-item", item)
          .append( $( "<a></a>" ).html( item.label || item.id ) )
          .appendTo(ul);
      };

      // replace with dropdown button once ready in twitter-bootstrap
      var button = this.button = $('<label class="add-on ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only" title="Show All Items" role="button"><span class="ui-button-icon-primary ui-icon ui-icon-triangle-1-s"></span><span class="ui-button-text">&nbsp;</span></label>')
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

      filtering_select.append(input).append(button).insertAfter(select);


    },

    _getResultSet: function(request, data, xhr) {
      var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");

      return $.map(data, function(el, i) {
        // match regexp only for local requests, remote ones are already filtered, and label may not contain filtered term.
        if ((el.id || el.value) && (xhr || matcher.test(el.label))) {
          return {
            label: el.label ? el.label.replace(
              new RegExp(
                "(?![^&;]+;)(?!<[^<>]*)(" +
                $.ui.autocomplete.escapeRegex(request.term) +
                ")(?![^<>]*>)(?![^&;]+;)", "gi"
             ), "<strong>$1</strong>") : el.id,
            value: el.label || el.id,
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
