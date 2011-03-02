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
        return { query: query }
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
      var widget = this;

      this.wrapper = $('<div class="ra-multiselect">');

      this.wrapper.insertAfter(this.element);

      this.header = $('<div class="ra-multiselect-header ui-helper-clearfix">');

      this.filter = $('<input type="text" class="ra-multiselect-search"/>');

      this.header.append(this.filter)
                 .append('<div class="help"><strong>Chosen teams</strong><br />Select your choice(s) and click</div><div class="ui-icon ui-icon-circle-triangle-e"></div>');

      this.wrapper.append(this.header);

      this.columns = {
        left: $('<div class="ra-multiselect-column ra-multiselect-left">'),
        center: $('<div class="ra-multiselect-column ra-multiselect-center">'),
        right: $('<div class="ra-multiselect-column ra-multiselect-right">')
      };

      for (var i in this.columns) { this.wrapper.append(this.columns[i]); };

      this.collection = $('<select multiple="multiple"></select>');

      this.collection.addClass("ra-multiselect-collection");

      this.addAll = $('<a class="ra-multiselect-item-add-all"><span class="ui-icon ui-icon-circle-triangle-e"></span>Add all</a>');

      this.columns["left"].append(this.collection)
                          .append(this.addAll);

      this.add = $('<a class="ui-icon ui-icon-circle-triangle-e ra-multiselect-item-add">Add</a>');

      this.remove = $('<a class="ui-icon ui-icon-circle-triangle-w ra-multiselect-item-remove">Remove</a>');

      this.columns["center"].append(this.add).append(this.remove);

      this.selection = $('<select multiple="multiple" class="ra-multiselect-selection"></select>');

      this.removeAll = $('<a class="ra-multiselect-item-remove-all"><span class="ui-icon ui-icon-circle-triangle-w"></span>Remove all</a>');

      this.columns["right"].append(this.selection)
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
            var html = "";

            for (key in matches) {
              if (!widget.selected(matches[key]["id"])) {
                html += '<option value="' + matches[key]["id"] + '">' + matches[key]["label"] + '</option>';
              }
            }            

            widget.collection.html(html);
          });
        }

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
      
      var matches = [];

      if (query == "") {

        if (!this.options.source) {
          for (key in this._cache) {
            matches.push({id: key, label: this._cache[key]});
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
          
          for (key in this._cache) {
            if (query.test(this._cache[key])) {
              matches.push({id: key, label: this._cache[key]});
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