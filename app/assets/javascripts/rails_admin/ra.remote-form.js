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

    _create: function() {
      var widget = this
      var dom_widget = widget.element;
      
      var edit_url = dom_widget.find('select').data('edit-url');
      if(typeof(edit_url) != 'undefined' && edit_url.length) {
        dom_widget.find('.ra-multiselect option').live('dblclick', function(e){
          widget._bindModalOpening(e, edit_url.replace('__ID__', this.value))
        });
      }

      dom_widget.find('.create').unbind().bind("click", function(e){
        widget._bindModalOpening(e, $(this).data('link'))
      });
      
      dom_widget.find('.update').unbind().bind("click", function(e){
        if(value = dom_widget.find('select').val()) {
          widget._bindModalOpening(e, $(this).data('link').replace('__ID__', value))
        } else {
          e.preventDefault();
        }
      });
    },
    
    _bindModalOpening: function(e, url) {
      e.preventDefault();
      widget = this;
      if($("#modal").length)
        return false;

      var dialog = this._getModal();
      $.ajax({
        url: url,
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
    },
    
    _bindFormEvents: function() {
      var widget = this,
          dialog = this._getModal(),
          form = dialog.find("form"),
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
          var select = widget.element.find('select').filter(":hidden");
          
          if(widget.element.find('.filtering-select').length) { // select input
            var input = widget.element.find('.filtering-select').children('.ra-filtering-select-input');
            input.val(json.label);
            if (!select.find('option[value=' + json.id + ']').length) // replace
              select.html(option).val(json.id);
          
          } else { // multi-select input
          
            var input = widget.element.find('.ra-filtering-select-input');
            var multiselect = widget.element.find('.ra-multiselect');
            if (multiselect.find('option[value=' + json.id + ']').length) { // replace
              select.find('option[value=' + json.id + ']').text(json.label);
              multiselect.find('option[value= ' + json.id + ']').text(json.label);
            } else { // add
              select.prepend(option);
              multiselect.find('select.ra-multiselect-selection').prepend(option);
            }
          }
          widget._trigger("success");
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
            show: true
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
