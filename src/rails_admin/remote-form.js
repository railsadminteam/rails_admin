import Rails from "@rails/ujs";
import jQuery from "jquery";
import "jquery-ui/ui/widget.js";
import * as bootstrap from "bootstrap";

(function ($) {
  $.widget("ra.remoteForm", {
    _create: function () {
      var widget = this;
      var dom_widget = widget.element;

      var edit_url =
        dom_widget.find("select").first().data("options") &&
        dom_widget.find("select").first().data("options")["edit-url"];
      if (typeof edit_url != "undefined" && edit_url.length) {
        dom_widget.on(
          "dblclick",
          ".ra-multiselect option:not(:disabled)",
          function (e) {
            widget._bindModalOpening(e, edit_url.replace("__ID__", this.value));
          }
        );
      }

      dom_widget
        .find(".create")
        .unbind()
        .bind("click", function (e) {
          widget._bindModalOpening(e, $(this).data("link"));
        });

      dom_widget
        .find(".update")
        .unbind()
        .bind("click", function (e) {
          var value = dom_widget.find("select").val();
          if (value) {
            widget._bindModalOpening(
              e,
              $(this).data("link").replace("__ID__", value)
            );
          } else {
            e.preventDefault();
          }
        });
    },

    _bindModalOpening: function (e, url) {
      e.preventDefault();
      var widget = this;
      if ($("#modal").length) return false;

      var dialog = this._getModal();

      setTimeout(function () {
        // fix race condition with modal insertion in the dom (Chrome => Team/add a new fan => #modal not found when it should have). Somehow .on('show') is too early, tried it too.
        $.ajax({
          url: url,
          beforeSend: function (xhr) {
            xhr.setRequestHeader("Accept", "text/javascript");
          },
          success: function (data, status, xhr) {
            dialog.find(".modal-body").html(data);
            widget._bindFormEvents();
          },
          error: function (xhr, status, error) {
            dialog.find(".modal-body").html(xhr.responseText);
          },
          dataType: "text",
        });
      }, 200);
    },

    _bindFormEvents: function () {
      var widget = this,
        dialog = this._getModal(),
        form = dialog.find("form"),
        saveButtonText = dialog.find(":submit[name=_save]").html(),
        cancelButtonText = dialog.find(":submit[name=_continue]").html();
      dialog.find(".form-actions").remove();

      form.attr("data-remote", true).attr("data-type", "json");
      dialog.find(".modal-header-title").text(form.data("title"));
      dialog
        .find(".cancel-action")
        .unbind()
        .click(function () {
          dialog.each(function (index, element) {
            bootstrap.Modal.getInstance(element).hide();
          });
          return false;
        })
        .html(cancelButtonText);

      dialog
        .find(".save-action")
        .unbind()
        .click(function () {
          Rails.fire(form[0], "submit");
          return false;
        })
        .html(saveButtonText);

      const event = new CustomEvent("rails_admin.dom_ready", { detail: form });
      document.dispatchEvent(event);

      form.bind("ajax:complete", function (event) {
        var data = event.detail[0];
        if (data.status == 200) {
          var json = $.parseJSON(data.responseText);
          var option =
            '<option value="' +
            json.id +
            '" selected>' +
            json.label +
            "</option>";
          var select = widget.element.find("select").filter(":hidden");

          if (widget.element.find(".filtering-select").length) {
            // select input
            var input = widget.element
              .find(".filtering-select")
              .children(".ra-filtering-select-input");
            input.val(json.label);
            if (!select.find("option[value=" + json.id + "]").length) {
              // not a replace
              select.html(option).val(json.id);
              widget.element.find(".update").removeClass("disabled");
            }
          } else {
            // multi-select input
            var multiselect = widget.element.find(".ra-multiselect");
            if (multiselect.find("option[value=" + json.id + "]").length) {
              // replace
              select.find("option[value=" + json.id + "]").text(json.label);
              multiselect
                .find("option[value= " + json.id + "]")
                .text(json.label);
            } else {
              // add
              select.append(option);
              multiselect
                .find("select.ra-multiselect-selection")
                .append(option);
            }
          }
          widget._trigger("success");
          dialog.each(function (index, element) {
            bootstrap.Modal.getInstance(element).hide();
          });
        } else {
          dialog.find(".modal-body").html(data.responseText);
          widget._bindFormEvents();
        }
      });
    },

    _getModal: function () {
      var widget = this;
      if (!widget.dialog) {
        widget.dialog = $(
          '<div id="modal" class="modal fade">\
            <div class="modal-dialog modal-lg">\
            <div class="modal-content">\
            <div class="modal-header">\
              <h3 class="modal-header-title">...</h3>\
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>\
            </div>\
            <div class="modal-body">\
              ...\
            </div>\
            <div class="modal-footer">\
              <a href="#" class="btn cancel-action">...</a>\
              <a href="#" class="btn btn-primary save-action">...</a>\
            </div>\
            </div>\
            </div>\
          </div>'
        ).on("hidden.bs.modal", function () {
          widget.dialog.remove(); // We don't want to reuse closed modals
          widget.dialog = null;
        });
        new bootstrap.Modal(widget.dialog[0], {
          keyboard: true,
          backdrop: true,
          focus: false,
          show: true,
        }).show();
      }
      return this.dialog;
    },
  });
})(jQuery);
