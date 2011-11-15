$ = jQuery

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

$("table#history th.header").live "click", ->
  window.location = $(this).data("link")

$(document).ready ->
  $('.pjax').pjax('[data-pjax-container]')
  $('.pjax-form').live 'submit', (event) ->
    event.preventDefault()
    $.pjax
      container: '[data-pjax-container]'
      url: this.action + (if (this.action.indexOf('?') != -1) then '&' else '?') + $(this).serialize()
  $(".alert-message").alert()
  $("[rel=twipsy]").twipsy()
  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')


