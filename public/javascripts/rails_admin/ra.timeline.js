/*
 * RailsAdmin Timeline @VERSION
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.draggable.js
 */
(function($) {
  $.widget("ra.timeline", {
    options: {
      date: new Date(),
      months: ['January','February','March','April','May','June','July','August','September','October','November','December'],
      range: 4,
      url: null
    },

    _create: function() {
      if (!this.options.url) alert("Timeline widget needs to be initialized with url option");

      this._build();
      this._bindEvents();
      this.refresh();
    },

    _build: function()
    {
      this.element.addClass("ra-timeline");

      this.next = $('<a class="range next" href="javascript:void();">Next</a>').appendTo(this.element);
      this.previous = $('<a class="range previous" href="javascript:void();">Previous</a>').appendTo(this.element);

      this.months = $('<ul></ul>').appendTo(this.element);

      this.handle = $('<div class="handle"></div>').appendTo(this.element);
    },

    _bindEvents: function()
    {
      var widget = this;

      /* Todo: Bind handle to update detailed listing from
       * "/admin/history/list" month changed */
      this.handle.draggable({
        axis: "x",
        containment: this.element
      });

      this.previous.bind("click.timeline", function(e){
        e.preventDefault();
        widget.options.date.setMonth(widget.options.date.getMonth() - 1 * widget.options.range);
        widget.refresh();
      });

      this.next.bind("click.timeline", function(e){
        e.preventDefault();
        widget.options.date.setMonth(widget.options.date.getMonth() + 1 * widget.options.range);
        widget.refresh();
      });
    },

    refresh: function()
    {
      this.months.find("li").remove();

      var i = this.options.range,
          date = new Date();

      date.setTime(this.options.date.valueOf());

      var width = Math.floor(this.months.width() / this.options.range) - 1;

      while (i--) {

        this.months.prepend(
          '<li style="width:' + width + 'px" data-month="' + date.getFullYear() + '' + (parseInt(date.getMonth()) + 1) + '">' +
            '<span class="month">' + this.getMonthName(date) + '</span>' +
            '<span class="bar"><span></span</span>' +
          '</li>'
        );

        date.setMonth(date.getMonth() - 1);
      }

      var widget = this;

      $.ajax({
        url: this.options.url,
        data: {
          from: {
            month: date.getMonth() + 1,
            year: date.getFullYear()
          },
          to: {
            month: this.options.date.getMonth() + 1,
            year: this.options.date.getFullYear()
          }
        },
        beforeSend: function(xhr) {
          xhr.setRequestHeader("Accept", "application/json");
        },
        success: function(data, status, xhr) {
          var maxHeight = widget.months.find(".bar").first().height(), max = 0;

          var getHistoryIndicator = function(history) {
            return widget.months.find("li[data-month=" + history.year + history.month + "]' .bar span").first();
          }

          $(data).each(function(i, e) {
            if (getHistoryIndicator(e.history).length && e.history.number > max) {
              max = e.history.number;
            }
          });

          $(data).each(function(i, e) {
            var className = "",
                el = getHistoryIndicator(e.history),
                height = 0,
                percent = 0;

            if (el.length) {
              if (e.history.number > 0) {
                percent = parseFloat(e.history.number / max);
                className = widget.getBarClass(percent);
                height = Math.floor(maxHeight * percent);
              }

              el.toggleClass(className, 300)
                .effect("size", { to: { height: height } }, 500);
            }
          });
        },
        error: function(xhr, status, error) {
          dialog.html(xhr.responseText);
        }
      });
    },

    getBarClass: function(percent) {
      if (percent < .33) {
        return "low";
      } else if (percent < .67) {
        return "medium";
      } else {
        return "high";
      }
    },

    getMonthName: function(date) {
      return this.options.months[date.getMonth()];
    }
  });
})(jQuery);