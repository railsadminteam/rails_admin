import jQuery from "jquery";
import "jquery-ui/ui/widget.js";
import I18n from "./i18n";
(function ($) {
  $.widget("ra.filteringMultiselect", {
    _cache: {},
    options: {
      createQuery: function (query) {
        return { query: query };
      },
      sortable: false,
      removable: true,
      regional: {
        add: "Add",
        chooseAll: "Choose all",
        clearAll: "Clear all",
        down: "Down",
        remove: "Remove",
        search: "Search",
        up: "Up",
      },
      searchDelay: 400,
      remote_source: null,
      xhr: false,
    },

    wrapper: null,
    filter: null,
    collection: null,
    addAll: null,
    add: null,
    remove: null,
    up: null,
    down: null,
    selection: null,
    removeAll: null,

    _create: function () {
      this._cache = {};
      this._build();
      this._buildCache();
      this._bindEvents();
    },

    _build: function () {
      var i;

      this.wrapper = this.element.siblings(
        '.ra-multiselect[data-input-for="' + this.element.attr("id") + '"]'
      );

      // Prevent duplication on browser back
      if (this.wrapper.length > 0) {
        this.filter = this.wrapper.find("input.ra-multiselect-search");
        this.collection = this.wrapper.find("select.ra-multiselect-collection");
        this.addAll = this.wrapper.find("a.ra-multiselect-item-add-all");
        this.add = this.wrapper.find("a.ra-multiselect-item-add");
        this.remove = this.wrapper.find("a.ra-multiselect-item-remove");
        this.up = this.wrapper.find("a.ra-multiselect-item-up");
        this.down = this.wrapper.find("a.ra-multiselect-item-down");
        this.selection = this.wrapper.find("select.ra-multiselect-selection");
        this.removeAll = this.wrapper.find("a.ra-multiselect-item-remove-all");
        return;
      }

      this.wrapper = $('<div class="ra-multiselect">').attr(
        "data-input-for",
        this.element.attr("id")
      );
      this.wrapper.insertAfter(this.element);
      var header = $('<div class="ra-multiselect-header">');
      this.filter = $(
        '<input type="search" placeholder="' +
          this.options.regional.search +
          '" class="form-control ra-multiselect-search"/>'
      );
      header.append(this.filter);
      this.wrapper.append(header);

      var columns = {
        left: $('<div class="ra-multiselect-column ra-multiselect-left">'),
        center: $('<div class="ra-multiselect-column ra-multiselect-center">'),
        right: $('<div class="ra-multiselect-column ra-multiselect-right">'),
      };

      for (i in columns) {
        if (columns.hasOwnProperty(i)) {
          this.wrapper.append(columns[i]);
        }
      }

      this.collection = $('<select multiple="multiple"></select>');
      this.collection.addClass("form-control ra-multiselect-collection");
      this.addAll = $(
        '<a href="#" class="ra-multiselect-item-add-all"><span class="fas fa-chevron-circle-right"></span>' +
          this.options.regional.chooseAll +
          "</a>"
      );
      columns.left.html(this.collection).append(this.addAll);
      this.collection.wrap('<div class="wrapper"/>');

      this.add = $(
        '<a href="#" class="fas fa-chevron-circle-right ra-multiselect-item-add"></a>'
      ).attr("title", this.options.regional.add);
      columns.center.append(this.add);
      if (this.options.removable) {
        this.remove = $(
          '<a href="#" class="fas fa-chevron-circle-left ra-multiselect-item-remove"></a>'
        ).attr("title", this.options.regional.remove);
        columns.center.append(this.remove);
      }
      if (this.options.sortable) {
        this.up = $(
          '<a href="#" class="fas fa-chevron-circle-up ra-multiselect-item-up"></a>'
        ).attr("title", this.options.regional.up);
        this.down = $(
          '<a href="#" class="fas fa-chevron-circle-down ra-multiselect-item-down"></a>'
        ).attr("title", this.options.regional.down);
        columns.center.append(this.up).append(this.down);
      }

      this.selection = $(
        '<select class="form-control ra-multiselect-selection" multiple="multiple"></select>'
      );
      columns.right.append(this.selection);
      if (this.options.removable) {
        this.removeAll = $(
          '<a href="#" class="ra-multiselect-item-remove-all"><span class="fas fa-chevron-circle-left"></span>' +
            this.options.regional.clearAll +
            "</a>"
        );
        columns.right.append(this.removeAll);
      }
      this.selection.wrap('<div class="wrapper"/>');

      this.element.css({ display: "none" });

      this.tooManyObjectsPlaceholder = $('<option disabled="disabled" />').text(
        I18n.t("too_many_objects")
      );
      this.noObjectsPlaceholder = $('<option disabled="disabled" />').text(
        I18n.t("no_objects")
      );

      if (this.options.xhr) {
        this.collection.append(this.tooManyObjectsPlaceholder);
      }
    },

    _bindEvents: function () {
      var widget = this;

      /* Add all to selection */
      this.addAll.click(function (e) {
        widget._select($("option:not(:disabled)", widget.collection));
        e.preventDefault();
        widget.selection.trigger("change");
      });

      /* Add to selection */
      this.add.click(function (e) {
        widget._select($(":selected", widget.collection));

        e.preventDefault();
        widget.selection.trigger("change");
      });

      if (this.options.removable) {
        /* Remove all from selection */
        this.removeAll.click(function (e) {
          widget._deSelect($("option", widget.selection));
          e.preventDefault();
          widget.selection.trigger("change");
        });

        /* Remove from selection */
        this.remove.click(function (e) {
          widget._deSelect($(":selected", widget.selection));
          e.preventDefault();
          widget.selection.trigger("change");
        });
      }

      var timeout = null;
      if (this.options.sortable) {
        /* Move selection up */
        this.up.click(function (e) {
          widget._move("up", $(":selected", widget.selection));
          e.preventDefault();
        });

        /* Move selection down */
        this.down.click(function (e) {
          widget._move("down", $(":selected", widget.selection));
          e.preventDefault();
        });
      }

      /* Typing to the filter */
      this.filter.bind("keyup click", function (e) {
        if (timeout) {
          clearTimeout(timeout);
        }
        timeout = setTimeout(function () {
          widget._queryFilter(widget.filter.val());
        }, widget.options.searchDelay);
      });
    },

    _queryFilter: function (val) {
      var widget = this;
      widget._query(val, function (matches) {
        var filtered = [];
        var i;

        for (i = 0; i < matches.length; i++) {
          if (!widget.selected(matches[i].id)) {
            filtered.push(i);
          }
        }
        if (filtered.length > 0) {
          widget.collection.html("");
          for (i = 0; i < filtered.length; i++) {
            var newOptions = $("<option></option>")
              .prop("value", matches[filtered[i]].id)
              .prop("title", matches[filtered[i]].label)
              .text(matches[filtered[i]].label);
            widget.collection.append(newOptions);
          }
        } else {
          widget.collection.html(widget.noObjectsPlaceholder);
        }
      });
    },

    /*
     * Cache key is stored in the format `o_<option value>` to avoid JS
     * engine coercing string keys to int keys, and thereby preserving
     * the insertion order. The value for each key is in turn an object
     * that stores the option tag's HTML text and the value. Example:
     * cache = {
     *    'o_271': { id: 271, value: 'CartItem #271'},
     *    'o_270': { id: 270, value: 'CartItem #270'}
     * }
     */
    _buildCache: function (options) {
      var widget = this;

      this.element.find("option").each(function (i, option) {
        widget._cache["o_" + option.value] = {
          id: option.value,
          value: $(option).text(),
        };
        if (option.selected) {
          $(option)
            .clone()
            .appendTo(widget.selection)
            .prop("selected", false)
            .prop("title", $(option).text());
        } else {
          $(option)
            .clone()
            .appendTo(widget.collection)
            .prop("selected", false)
            .prop("title", $(option).text());
        }
      });
    },

    _deSelect: function (options) {
      var widget = this;
      options.each(function (i, option) {
        widget.element
          .find('option[value="' + option.value + '"]')
          .prop("selected", false);
      });
      $(options).appendTo(this.collection).prop("selected", false);
    },

    _query: function (query, success) {
      var i,
        matches = [];

      if (query === "") {
        if (!this.options.xhr) {
          for (i in this._cache) {
            if (this._cache.hasOwnProperty(i)) {
              var option = this._cache[i];
              matches.push({ id: option.id, label: option.value });
            }
          }
          success.apply(this, [matches]);
        } else {
          this.collection.html(this.tooManyObjectsPlaceholder);
        }
      } else {
        if (this.options.xhr) {
          $.ajax({
            beforeSend: function (xhr) {
              xhr.setRequestHeader("Accept", "application/json");
            },
            url: this.options.remote_source,
            data: this.options.createQuery(query),
            success: success,
          });
        } else {
          query = new RegExp(query + ".*", "i");

          for (i in this._cache) {
            if (
              this._cache.hasOwnProperty(i) &&
              query.test(this._cache[i]["value"])
            ) {
              var option = this._cache[i];
              matches.push({ id: option.id, label: option.value });
            }
          }

          success.apply(this, [matches]);
        }
      }
    },

    _select: function (options) {
      var widget = this;
      options.each(function (i, option) {
        var el = widget.element.find('option[value="' + option.value + '"]');
        if (el.length) {
          el.prop("selected", true);
        } else {
          widget.element.append(
            $("<option></option>")
              .prop("value", option.value)
              .prop("selected", true)
          );
        }
      });
      $(options).appendTo(this.selection).prop("selected", false);
    },

    _move: function (direction, options) {
      var widget = this;
      if (direction == "up") {
        options.each(function (i, option) {
          var prev = $(option).prev();
          if (prev.length > 0) {
            var el = widget.element.find(
              'option[value="' + option.value + '"]'
            );
            var el_prev = widget.element.find(
              'option[value="' + prev[0].value + '"]'
            );
            el_prev.before(el);
            prev.before($(option));
          }
        });
      } else {
        $.fn.reverse = [].reverse; // needed to lower last items first
        options.reverse().each(function (i, option) {
          var next = $(option).next();
          if (next.length > 0) {
            var el = widget.element.find(
              'option[value="' + option.value + '"]'
            );
            var el_next = widget.element.find(
              'option[value="' + next[0].value + '"]'
            );
            el_next.after(el);
            next.after($(option));
          }
        });
      }
    },

    selected: function (value) {
      if (
        this.selection[0].querySelectorAll('option[value="' + value + '"]')[0]
      ) {
        return true;
      }
    },

    destroy: function () {
      this.wrapper.remove();
      this.element.css({ display: "inline" });
      $.Widget.prototype.destroy.apply(this, arguments);
    },
  });
})(jQuery);
