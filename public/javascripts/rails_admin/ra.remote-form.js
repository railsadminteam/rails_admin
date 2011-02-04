/*
 * RailsAdmin remote form @VERSION
 *
 * License
 *
 * http://www.railsadmin.org
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.dialog.js
 */
(function($) {
  $.widget("ra.remoteForm", {
    dialog: null,
    options: {
      dialogClass: "",
      width: 720
    },

    _create: function() {
      var widget = this;
      $(widget.element).bind("click", function(e){
        e.preventDefault();
        var dialog = widget._getDialog();
        $.ajax({
          url: $(this).attr("href"),
          beforeSend: function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript");
          },
          success: function(data, status, xhr) {
            /* Todo: Parse header to dialog title */
            dialog.html(data);
            widget._bindFormEvents();
          },
          error: function(xhr, status, error) {
            dialog.html(xhr.responseText);
          }
        });
      });
    },

    _bindFormEvents: function() {
      var dialog = this._getDialog(),
          form = dialog.find("form"),
          widget = this;

      form.bind("ajax:success", function(e, data, status, xhr) {
        var input = widget.element.prev(), json = $.parseJSON(data);
        input.append('<option value="' + json["id"] + '">' + json["label"] + '</option>' );
        dialog.dialog("close");
      });

      form.bind("ajax:error", function(e, xhr, status, error) {
        dialog.html(xhr.responseText);
        widget._bindFormEvents();
      });

      form.find("input[name=_save]").bind("click", function(e) {
          e.preventDefault();
          form.callRemote();
      });

      form.find("input[name=_continue]").bind("click", function(e) {
          e.preventDefault();
          dialog.dialog("close");
      });
    },

    _getDialog: function() {
      if (!this.dialog) {
        var widget = this;
        this.dialog = $('<div class="' + this.options["dialogClass"] + '"></div>').dialog({
          autoShow: false,
          close: function(e, ui) {
            $(this).dialog("destroy");
            $(this).remove();
            widget.dialog = null;
          },
          modal: true,
          width: this.options["width"]
        });
      }
      return this.dialog;
    }
  });
})(jQuery);