/*
 * RailsAdmin date/time picker @VERSION
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.datepicker.js
 *   jquery.ui.timepicker.js (http://plugins.jquery.com/project/timepicker-by-fgelinas)
 */
(function($) {

  $.widget("ra.datetimepicker", {
    options: {
      showDate: true,
      showTime: true,
      datepicker: {},
      timepicker: {}
    },

    _create: function() {
      var widget = this;
      this.element.hide();

      if (this.options.showTime) {
        var $wrap = $('<div class="input-group"/>');

        this.timepicker = $('<input class="TIMEPICKER" type="text" value="' + this.options.timepicker.value + '" />');

        this.timepicker.css("width", "65px");

        this.timepicker.addClass('form-control');

        $wrap.append(this.timepicker);

        $wrap.append($('<div class="input-group-addon"><i class="icon-time"></i></div>'));

        $wrap.insertAfter(this.element);

        this.timepicker.bind("change", function() { widget._onChange(); });

        this.timepicker.timepicker(this.options.timepicker);
      }

      if (this.options.showDate) {
        var $wrap = $('<div class="input-group"/>');

        this.datepicker = $('<input type="text" value="' + this.options.datepicker.value + '" />');

        this.datepicker.addClass('form-control');

        $wrap.css("margin-right", "15px");

        $wrap.append(this.datepicker);

        $wrap.append($('<div class="input-group-addon"><i class="icon-calendar"></i></div>'));

        $wrap.insertAfter(this.element);

        this.datepicker.bind("change", function() { widget._onChange(); });

        this.datepicker.datepicker(this.options.datepicker);
      }
    },

    _onChange: function() {
      var value = [];

      if (this.options.showDate) {
        value.push(this.datepicker.val());
      }

      if (this.options.showTime) {
        value.push(this.timepicker.val());
      }

      this.element.val(value.join(" "));
    }
  });
})(jQuery);
