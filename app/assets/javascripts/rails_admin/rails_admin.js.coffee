//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//= require_tree .
//= require_self

$ = jQuery.noConflict()

$("#list input.checkbox.toggle").live "click", ->
  checked_status = $(this).is(":checked")
  $("td.action.select input.checkbox[name='bulk_ids[]']").each ->
    $(this).attr "checked", checked_status
    if checked_status
      $(this).parent().addClass "checked"
    else
      $(this).parent().removeClass "checked"

$("#list a, #list form").live "ajax:complete", (xhr, data, status) ->
  $("#list").replaceWith data.responseText

$("#list table th.header").live "click", ->
  $.ajax 
    url: $(this).data("link")
    success: (data) ->
      $("#list").replaceWith data

$("table#history th.header").live "click", ->
  window.location = $(this).data("link")

$(document).ready ->
  $(".alert-message").alert()
  $("[rel=twipsy]").twipsy()
