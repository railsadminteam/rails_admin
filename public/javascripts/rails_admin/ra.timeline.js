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
      monthChanged: function(month, year) {},
      months: ['January','February','March','April','May','June','July','August','September','October','November','December'],
      range: 4,
      url: null
    },

    _create: function() {
      if (!this.options.url) {
        alert("Timeline widget needs to be initialized with url option");
      }

      this._build();
      this._bindEvents();
      this.refresh();
    },

    _build: function() {
      this.element.addClass("ra-timeline");

      this.next = $('<a class="range next" href="javascript:void();">Next</a>').appendTo(this.element);
      this.previous = $('<a class="range previous" href="javascript:void();">Previous</a>').appendTo(this.element);

      this.months = $('<ul></ul>').appendTo(this.element);

      this.handle = $('<div class="handle"></div>').appendTo(this.element);

      this.handleOffset = parseInt(this.element.css("padding-left"), 10);

      this._moveHandleToRight();
    },

    _bindEvents: function() {
      var currentMonthIndex = 0,
          widget = this;

      $(window).resize(function() {
        widget.redraw();
      });

      this.handle.draggable({
        axis: "x",
        containment: this.element,
        drag: function(event, ui) {
          var i = Math.floor((ui.position.left - widget.handleOffset) / widget.monthWidth);

          if (i !== currentMonthIndex) {
              currentMonthIndex = i;

              var el = $(widget.months.children().get(i)),
                  month = el.attr("data-month"),
                  year = el.attr("data-year");

              widget.options.monthChanged(month, year);
          }
        }
      });

      this.previous.bind("click.timeline", function(e){
        e.preventDefault();
        widget.options.date.setMonth(widget.options.date.getMonth() - widget.options.range);
        widget._moveHandleToRight();
        widget.options.monthChanged(
          widget.options.date.getMonth() + 1,
          widget.options.date.getFullYear()
        );
        widget.refresh();
      });

      this.next.bind("click.timeline", function(e){
        e.preventDefault();
        var date = widget._getNextMonthDate();
        widget.options.monthChanged(
          date.getMonth() + 1,
          date.getFullYear()
        );
        widget.options.date.setMonth(widget.options.date.getMonth() + widget.options.range);
        widget._moveHandleToLeft();
        widget.refresh();
      });
    },

    _getCurrentDate: function() {
      return new Date(this.options.date.getFullYear(), this.options.date.getMonth(), 1);
    },

    _getNextMonthDate: function() {
      var date = this._getCurrentDate();
      date.setMonth(this.options.date.getMonth() + 1);
      return date;
    },

    _getPreviousMonthDate: function() {
      var date = this._getCurrentDate();
      date.setMonth(this.options.date.getMonth() - 1);
      return date;
    },

    _moveHandleToLeft: function() {
      this.handle.css("left", this.handleOffset);
    },

    _moveHandleToRight: function() {
      this.handle.css("left", this.months.width() - this.handle.width() + this.handleOffset);
    },

    redraw: function() {
      this.months.find("li").remove();

      var i = this.options.range,
          date = this._getCurrentDate();

      this.monthWidth = Math.floor(this.months.width() / this.options.range) - 1;

      while (i--) {
        this.months.prepend(
          '<li style="width:' + this.monthWidth + 'px" data-year="' + date.getFullYear() + '" data-month="' + (parseInt(date.getMonth(), 10) + 1) + '">' +
            '<span class="month">' + this.getMonthName(date) + '</span>' +
            '<span class="bar"><span></span></span>' +
          '</li>'
        );

        date.setMonth(date.getMonth() - 1);
      }

      // FIXME should really be keeping the handle in the same place
      // proportionally, but this keeps it from looking too broken:
      this._moveHandleToRight();
    },

    refresh: function() {
      this.redraw();

      var widget = this;
      var date = this._getCurrentDate();

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
            return widget.months.find("li[data-year=" + history.year + "][data-month=" + history.month + "] .bar span").first();
          };

          $(data).each(function(i, e) {
            if (getHistoryIndicator(e.history).length && e.history.record_count > max) {
              max = e.history.record_count;
            }
          });

          $(data).each(function(i, e) {
            var className = "",
                el = getHistoryIndicator(e.history),
                height = 0,
                percent = 0;

            if (el.length) {
              if (e.history.record_count > 0) {
                percent = parseFloat(e.history.record_count / max);
                className = widget.getBarClass(percent);
                height = Math.floor(maxHeight * percent);
              }

              el.toggleClass(className, 300)
                .animate( { height: height }, 1000, 'easeOutBounce');
            }
          });
        },
        error: function(xhr, status, error) {
          dialog.html(xhr.responseText);
        }
      });
    },

    getBarClass: function(percent) {
      if (percent < 0.33) {
        return "low";
      } else if (percent < 0.67) {
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
