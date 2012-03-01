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
        this.timepicker = $('<input class="TIMEPICKER" type="text" value="' + this.options.timepicker.value + '" />');

        this.timepicker.css("width", "60px");

        this.timepicker.insertAfter(this.element);

        this.timepicker.bind("change", function() { widget._onChange(); });

        this.timepicker.timepicker(this.options.timepicker);
      }

      if (this.options.showDate) {
        this.datepicker = $('<input type="text" value="' + this.options.datepicker.value + '" />');

        this.datepicker.css("margin-right", "10px");

        this.datepicker.insertAfter(this.element);

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
