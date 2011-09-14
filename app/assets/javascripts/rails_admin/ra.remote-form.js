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
      height: 600,
      width: 720
    },

    _create: function() {
      var widget = this;
      var edit_url = $(this.element).siblings('select').data('edit-url');
      if(typeof(edit_url) != 'undefined' && edit_url.length) {
        $('#' + this.element.parent().attr('id') + ' .input.ra-multiselect option').live('dblclick', function(e){
          e.preventDefault();
          var dialog = widget._getDialog();
          $.ajax({
            url: edit_url.replace('__ID__', this.value),
            beforeSend: function(xhr) {
              xhr.setRequestHeader("Accept", "text/javascript");
            },
            success: function(data, status, xhr) {
              dialog.html(data);
              widget._bindFormEvents();
            },
            error: function(xhr, status, error) {
              dialog.html(xhr.responseText);
            },
            dataType: 'text'
          });
        });
      }


      $(widget.element).bind("click", function(e){
        e.preventDefault();
        var dialog = widget._getDialog();
        $.ajax({
          url: $(this).attr("href"),
          beforeSend: function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript");
          },
          success: function(data, status, xhr) {
            dialog.html(data);
            widget._bindFormEvents();
          },
          error: function(xhr, status, error) {
            dialog.html(xhr.responseText);
          },
          dataType: 'text'
        });
      });
    },



    _bindFormEvents: function() {
      var dialog = this._getDialog(),
          form = dialog.find("form"),
          widget = this,
          saveButtonText = dialog.find(":submit[name=_save]").text(),
          cancelButtonText = dialog.find(":submit[name=_continue]").text();

      // Hide delete/history buttons, not supported yet.
      dialog.find('div.control').hide();

      dialog.dialog("option", "title", $("h2.title", dialog).remove().text());

      form.attr("data-remote", true);
      dialog.find(":submit").remove();
      dialog.find(".ra-block-content").removeClass("ra-block-content");

      var buttons = {};

      if (saveButtonText) {
        buttons[saveButtonText] = function() {
          if(typeof CKEDITOR != 'undefined') {
            for ( instance in CKEDITOR.instances )
              CKEDITOR.instances[instance].updateElement();
              CKEDITOR.instances[instance].destroy();
          }
          dialog.find("form").submit();
        };
      }

      if (cancelButtonText) {
        buttons[cancelButtonText] = function() {
          dialog.dialog("close");
        };
      }

      dialog.dialog("option", "buttons", buttons);

      /* Remove original button container if it's now empty */
      if (0 == $("form > .navform :submit", dialog).length) {
        $("form > .navform", dialog).remove();
      }
      
      
      $('form').live("ajax:complete", function(xhr, data, status) {
        var json = $.parseJSON(data.responseText);
        var select = widget.element.siblings('select');
        var input = widget.element.siblings('.ra-filtering-select-input');
        var option = '<option value="' + json.id + '" selected>' + json.label + '</option>';

        if(widget.element.siblings('button').length){ // select input (add)
          if(input.length > 0) {
            input[0].value = json.label;
          }
          if(select.length > 0) {
            select.html(option);
            select[0].value = json.id;
          }
        }
        else{ // multi-select input
          var multiselect = widget.element.siblings('.input.ra-multiselect');
          if (select.find('option[value=' + json.id + ']').length) { // replace (changing name may be needed)
            select.find('option[value=' + json.id + ']').text(json.label);
            multiselect.find('option[value= ' + json.id + ']').text(json.label);
          } else { // add
            select.prepend(option);
            multiselect.find('select.ra-multiselect-selection').prepend(option);
          }
        }
        dialog.dialog("close");
      });

      $('form').live("ajax:error", function(e, xhr, status, error) {
        dialog.html(xhr.responseText);
        widget._bindFormEvents();
      });
    },

    _getDialog: function() {
      if (!this.dialog) {
        var widget = this;
        this.dialog = $('<div class="' + this.options.dialogClass + '"></div>').dialog({
          autoShow: false,
          close: function(e, ui) {
            $(this).dialog("destroy");
            $(this).remove();
            widget.dialog = null;
          },
          modal: true,
          width: this.options.width,
          height: this.options.height
        });
      }
      return this.dialog;
    }
  });
})(jQuery);
