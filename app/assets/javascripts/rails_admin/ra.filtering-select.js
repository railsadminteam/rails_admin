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
  'use strict';

  $.widget('ra.filteringSelect', {
    options: {
      createQuery: function(query) {
        if (location.pathname.startsWith('/admin/terminal')) {
          if (query.length == 0) return null;
          return {f: { auth_code: {1: {o: 'like', v: query}}}};
        }

        return { query: query };
      },
      minLength: 0,
      searchDelay: 600,
      remote_source: null,
      source: null,
      float_left: true,
      xhr: false
    },

    button: null,
    input: null,
    select: null,

    _create: function() {
      var filtering_select = this.element.siblings(
        '[data-input-for="' + this.element.attr('id') + '"]'
      );

      // When using the browser back and forward buttons, it is possible that
      // the autocomplete field will be cached which causes duplicate fields
      // to be generated.
      if (filtering_select.length > 0) {
        this.input = filtering_select.children('input');
        this.button = filtering_select.children('.input-group-btn');
      } else {
        this.element.hide();
        filtering_select = this._inputGroup(this.element.attr('id'));
        this.input = this._inputField();
        this.button = this._buttonField();
      }
<<<<<<< HEAD

      var filtering_select = $('<div class="input-group filtering-select col-sm-2"></div>')
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
          .append( $( "<a></a>" ).html( item.html || item.id ) )
          .appendTo(ul);
      };

      var button = this.button = $('<span class="input-group-btn"><label class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Show All Items" role="button"><span class="caret"></span><span class="ui-button-text">&nbsp;</span></label></span>')
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
=======
>>>>>>> v1.2.0

      this._setOptionsSource();
      this._initAutocomplete();
      this._initKeyEvent();
      this._overloadRenderItem();
      this._autocompleteDropdownEvent(this.button);

      return filtering_select.append(this.input)
        .append(this.button)
        .insertAfter(this.element);
    },

    _getResultSet: function(request, data, xhr) {
      var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), 'i');

      var spannedContent = function(content) {
        return $('<span>').text(content).html();
      };

      var highlighter = function(label, word) {
        if(word.length) {
          return $.map(
            label.split(word),
            function(el) {
              return spannedContent(el);
            })
            .join($('<strong>')
            .text(word)[0]
            .outerHTML
          );
        } else {
          return spannedContent(label);
        }
      };

      return $.map(
        data,
        function(el) {
          var id = el.id || el.value;
          var value = el.label || el.id;
          // match regexp only for local requests, remote ones are already
          // filtered, and label may not contain filtered term.
          if (id && (xhr || matcher.test(el.label))) {
            return {
              html: highlighter(value, request.term),
              value: value,
              id: id
            };
          }
      });
    },

    _getSourceFunction: function(source) {
      var self = this;
      var requestIndex = 0;

      if ($.isArray(source)) {
        return function(request, response) {
          response(self._getResultSet(request, source, false));
        };
      } else if (typeof source === 'string') {
        return function(request, response) {

          data = self.options.createQuery(request.term)
          if (!data) return response([]);
          if (this.xhr) this.xhr.abort();

          this.xhr = $.ajax({
            url: source,
            data: self.options.createQuery(request.term),
            dataType: 'json',
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

    _setOptionsSource: function() {
      if (this.options.xhr) {
        this.options.source = this.options.remote_source;
      } else {
        this.options.source = this.element.children('option').map(function() {
          return { label: $(this).text(), value: this.value };
        }).toArray();
      }
    },

    _buttonField: function() {
      return $(
        '<span class="input-group-btn">' +
          '<label class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Show All Items" role="button">' +
            '<span class="caret"></span>' +
            '<span class="ui-button-text">&nbsp;</span>' +
          '</label>' +
        '</span>'
      );
    },

    _autocompleteDropdownEvent: function(element) {
      var self = this;

      return element.click(function() {
        // close if already visible
        if (self.input.autocomplete('widget').is(':visible')) {
          self.input.autocomplete('close');
          return;
        }

        // pass empty string as value to search for, displaying all results
        self.input.autocomplete('search', '');
        self.input.focus();
      });
    },

    _inputField: function() {
      var input;
      var selected = this.element.children(':selected');
      var value = selected.val() ? selected.text() : '';

      input = $('<input type="text">')
        .val(value)
        .addClass('form-control ra-filtering-select-input')
        .attr('style', this.element.attr('style'))
        .show();

      if (this.element.attr('placeholder')) {
        input.attr('placeholder', this.element.attr('placeholder'));
      }

      return input;
    },

    _inputGroup: function(inputFor) {
      return $('<div>')
        .addClass('input-group filtering-select col-sm-2')
        .attr('data-input-for', inputFor)
        .css('float', 'left');
    },

    _initAutocomplete: function() {
      var self = this;

      return this.input.autocomplete({
        delay: this.options.searchDelay,
        minLength: this.options.minLength,
        source: this._getSourceFunction(this.options.source),
        select: function(event, ui) {
          var option = $('<option>')
            .attr('value', ui.item.id)
            .attr('selected', 'selected')
            .text(ui.item.value);
          self.element.html(option)
            .trigger('change', ui.item.id);
          self._trigger('selected', event, {
            item: option
          });
          $(self.element.parents('.controls')[0])
            .find('.update')
            .removeClass('disabled');
        },
        change: function(event, ui) {
          if (ui.item) {
            return;
          }

          var matcher = new RegExp('^' + $.ui.autocomplete.escapeRegex($(this).val()) + '$', 'i');
          var valid = false;

          self.element.children('option')
            .each(function() {
              if ($(this).text().match(matcher)) {
                valid = true;
                return false;
              }
            });

          if (valid || $(this).val() !== '') {
            return;
          }

          // remove invalid value, as it didn't match anything
          $(this).val(null);
          self.element.html($('<option value="" selected="selected"></option>'));
          self.input.data('ui-autocomplete').term = '';
          $(self.element.parents('.controls')[0])
            .find('.update')
            .addClass('disabled');
          return false;
        }
      });
    },

    _initKeyEvent: function() {
      var self = this;

      return this.input.keyup(function() {
        if ($(this).val().length) {
          return;
        }

        /* Clear select options and trigger change if selected item is deleted */
        return self.element
          .html($('<option value="" selected="selected"></option>'))
          .trigger('change');
      });
    },

    _overloadRenderItem: function() {
      this.input.data('ui-autocomplete')._renderItem = function(ul, item) {
        return $('<li></li>')
          .data('ui-autocomplete-item', item)
          .append($('<a></a>')
          .html(item.html || item.id))
          .appendTo(ul);
      };
    },

    destroy: function() {
      this.input.remove();
      this.button.remove();
      this.element.show();
      $.Widget.prototype.destroy.call(this);
    }
  });
})(jQuery);
