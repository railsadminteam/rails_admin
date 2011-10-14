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
        $('#' + this.element.parent().parent().attr('id') + ' .ra-multiselect option').live('dblclick', function(e){
          e.preventDefault();
          if($("#modal").length) {
            return false; // Only one modal at a time
          }

          var dialog = widget._getModal();
          $.ajax({
            url: edit_url.replace('__ID__', this.value),
            beforeSend: function(xhr) {
              xhr.setRequestHeader("Accept", "text/javascript");
            },
            success: function(data, status, xhr) {
              dialog.find('.modal-body').html(data);
              widget._bindFormEvents();
            },
            error: function(xhr, status, error) {
              dialog.find('.modal-body').html(xhr.responseText);
            },
            dataType: 'text'
          });
        });
      }


      $(widget.element).bind("click", function(e){
        e.preventDefault();
        if($("#modal").length) {
          return false; // Only one modal at a time
        }

        var dialog = widget._getModal();
        $.ajax({
          url: $(this).attr("href"),
          beforeSend: function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript");
          },
          success: function(data, status, xhr) {
            dialog.find('.modal-body').html(data);
            widget._bindFormEvents();
          },
          error: function(xhr, status, error) {
            dialog.find('.modal-body').html(xhr.responseText);
          },
          dataType: 'text'
        });
      });
    },
    
    _bindFormEvents: function() {
      var dialog = this._getModal(),
          form = dialog.find("form"),
          widget = this,
          saveButtonText = dialog.find(":submit[name=_save]").text(),
          cancelButtonText = dialog.find(":submit[name=_continue]").text();
          
      dialog.find('.actions').remove();
      
      form.attr("data-remote", true);
      
      dialog.find('.modal-header-title').text(form.data('title'));
      
      dialog.find('.cancel-action').unbind().click(function(){
        dialog.modal('hide');
        return false;
      }).text(cancelButtonText);
      
      dialog.find('.save-action').unbind().click(function(){
        form.submit();
        return false;
      }).text(saveButtonText);
      
      form.bind("ajax:complete", function(xhr, data, status) {
        if (status == 'error') {
          dialog.find('.modal-body').html(data.responseText);
          widget._bindFormEvents();

        } else {

          var json = $.parseJSON(data.responseText);
          var option = '<option value="' + json.id + '" selected>' + json.label + '</option>';
          var select = widget.element.siblings('select');
          
          if(widget.element.siblings('.input-append').length) { // select input (add)
            
            var input = widget.element.siblings('.input-append').children('.ra-filtering-select-input');
            if(input.length > 0) {
              input[0].value = json.label;
            }
            if(select.length > 0) {
              select.html(option);
              select[0].value = json.id;
            }
          } else { // multi-select input
            
            var input = widget.element.siblings('.ra-filtering-select-input');
            var multiselect = widget.element.siblings('.ra-multiselect');
            if (select.find('option[value=' + json.id + ']').length) { // replace (changing name may be needed)
              select.find('option[value=' + json.id + ']').text(json.label);
              multiselect.find('option[value= ' + json.id + ']').text(json.label);
            } else { // add
              select.prepend(option);
              multiselect.find('select.ra-multiselect-selection').prepend(option);
            }
          }
          dialog.modal("hide");
        }
      });
    },
    
    _getModal: function() {
      var widget = this;
      if (!widget.dialog) {
        widget.dialog = $('\
          <div id="modal" class="modal">\
            <div class="modal-header">\
              <a href="#" class="close">&times;</a>\
              <h3 class="modal-header-title">...</h3>\
            </div>\
            <div class="modal-body">\
              ...\
            </div>\
            <div class="modal-footer">\
              <a href="#" class="btn secondary cancel-action">...</a>\
              <a href="#" class="btn primary save-action">...</a>\
            </div>\
          </div>')
          .modal({
            keyboard: true,
            backdrop: true,
            show:true
          })
          .bind('hidden', function(){
            widget.dialog.remove();   // We don't want to reuse closed modals
            widget.dialog = null;
          });
        }
      return this.dialog;
    }
  });
})(jQuery);
