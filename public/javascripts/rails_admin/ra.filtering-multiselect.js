/*
 * RailsAdmin filtering multiselect @VERSION
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 */
(function($) {
  $.widget("ra.filteringMultiselect", {
    _cache: {},
    options: {
      createQuery: function(query) {
        return { query: query };
      },
      regional: {
        add: "Add",
        chooseAll: "Choose all",
        chosen: "Chosen records",
        clearAll: "Clear all",
        remove: "Remove",
        selectChoice: "Select your choice(s) and click"
      },
      searchDelay: 400,
      source: null
    },

    _create: function() {
      this._cache = {};
      this._build();
      this._bindEvents();
      this._buildCache();
    },

    _build: function() {
      var i;

      this.wrapper = $('<div class="ra-multiselect">');

      this.wrapper.insertAfter(this.element);

      this.header = $('<div class="ra-multiselect-header ui-helper-clearfix">');

      this.filter = $('<input type="text" class="ra-multiselect-search"/>');

      this.header.append(this.filter)
                 .append('<div class="help"><strong>' + this.options.regional.chosen + '</strong><br />' + this.options.regional.selectChoice + '</div><div class="ui-icon ui-icon-circle-triangle-e"></div>');

      this.wrapper.append(this.header);

      this.columns = {
        left: $('<div class="ra-multiselect-column ra-multiselect-left">'),
        center: $('<div class="ra-multiselect-column ra-multiselect-center">'),
        right: $('<div class="ra-multiselect-column ra-multiselect-right">')
      };

      for (i in this.columns) {
        if (this.columns.hasOwnProperty(i)) {
          this.wrapper.append(this.columns[i]);
        }
      }

      this.collection = $('<select multiple="multiple"></select>');

      this.collection.addClass("ra-multiselect-collection");

      this.addAll = $('<a class="ra-multiselect-item-add-all"><span class="ui-icon ui-icon-circle-triangle-e"></span>' + this.options.regional.chooseAll + '</a>');

      this.columns.left.append(this.collection)
                          .append(this.addAll);

      this.add = $('<a class="ui-icon ui-icon-circle-triangle-e ra-multiselect-item-add">' + this.options.regional.add + '</a>');

      this.remove = $('<a class="ui-icon ui-icon-circle-triangle-w ra-multiselect-item-remove">' + this.options.regional.remove + '</a>');

      this.columns.center.append(this.add).append(this.remove);

      this.selection = $('<select multiple="multiple" class="ra-multiselect-selection"></select>');

      this.removeAll = $('<a class="ra-multiselect-item-remove-all"><span class="ui-icon ui-icon-circle-triangle-w"></span>' + this.options.regional.clearAll + '</a>');

      this.columns.right.append(this.selection)
                           .append(this.removeAll);

      this.element.css({display: "none"});
    },

    _bindEvents: function() {
      var widget = this;

      /* Add all to selection */
      this.addAll.click(function(e){
        widget._select($('option', widget.collection));
      });

      /* Add to selection */
      this.add.click(function(e){
        widget._select($(':selected', widget.collection));
      });

      /* Remove all from selection */
      this.removeAll.click(function(e){
        widget._deSelect($('option', widget.selection));
      });

      /* Remove from selection */
      this.remove.click(function(e){
        widget._deSelect($(':selected', widget.selection));
      });

      var timeout = null;

      /* Typing to the filter */
      this.filter.keyup(function(e){

        if (timeout) { clearTimeout(timeout); }

        var search = function() {

          widget._query(widget.filter.val(), function(matches) {
            var i, html = "";
            for (i in matches) {
              if (matches.hasOwnProperty(i) && !widget.selected(matches[i].id)) {
                html += '<option value="' + matches[i].id + '">' + matches[i].label + '</option>';
              }
            }

            widget.collection.html(html);
          });
        };

        timeout = setTimeout(search, widget.options.searchDelay);
      });
    },

    _buildCache: function(options) {
      var widget = this;

      this.element.find("option").each(function(i, option) {
        if (option.selected) {
          widget._cache[option.value] = option.innerHTML;
          $(option).clone().appendTo(widget.selection).attr("selected", false);
        } else {
          widget._cache[option.value] = option.innerHTML;
          $(option).clone().appendTo(widget.collection).attr("selected", false);
        }
      });
    },

    _deSelect: function(options) {
      var widget = this;
      options.each(function(i, option) {
        widget.element.find("option[value=" + option.value + "]").removeAttr("selected");
      });
      $(options).appendTo(this.collection).attr('selected', false);
    },

    _query: function(query, success) {

      var i, matches = [];

      if (query === "") {

        if (!this.options.source) {

          for (i in this._cache) {
            if (this._cache.hasOwnProperty(i)) {
              matches.push({id: i, label: this._cache[i]});
            }
          }
        }

        success.apply(this, [matches]);

      } else {

        if (this.options.source) {

          $.ajax({
            beforeSend: function(xhr) {
              xhr.setRequestHeader("Accept", "application/json");
            },
            url: this.options.source,
            data: this.options.createQuery(query),
            success: success
          });

        } else {

          query = new RegExp(query + '.*', 'i');

          for (i in this._cache) {
            if (this._cache.hasOwnProperty(i) && query.test(this._cache[i])) {
              matches.push({id: i, label: this._cache[i]});
            }
          }

          success.apply(this, [matches]);
        }
      }
    },

    _select: function(options) {
      var widget = this;
      options.each(function(i, option) {
        var el = widget.element.find("option[value=" + option.value + "]");
        if (el.length) {
          el.attr("selected", "selected");
        } else {
          widget.element.append($('<option value="' + option.value + '" selected="selected"></option>'));
        }
      });
      $(options).appendTo(this.selection).attr('selected', false);
    },

    selected: function(value) {
      return this.element.find("option[value=" + value + "]").attr("selected");
    },

    destroy: function() {
      this.wrapper.remove();
      this.element.css({display: "inline"});
      $.Widget.prototype.destroy.apply(this, arguments);
    }
  });
})(jQuery);
