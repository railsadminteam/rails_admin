$ = jQuery

$("#list input.checkbox.toggle").on "click", ->
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
  if $(this).data("link")
    window.location = $(this).data("link")
  
$(document).ready ->
  
  $('.pjax').pjax('[data-pjax-container]')
  
  $('.pjax-form').live 'submit', (event) ->
    event.preventDefault()
    $.pjax
      container: '[data-pjax-container]'
      url: this.action + (if (this.action.indexOf('?') != -1) then '&' else '?') + $(this).serialize()
  
  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')
    
  $('.form-horizontal legend').has('i.icon-chevron-right').each ->
    $(this).siblings('.control-group').hide()

  $('[rel=tooltip]').tooltip(delay: { show: 200, hide: 500 });

  $('[data-target]').live 'click', ->
    if !$(this).hasClass('disabled')
      if $(this).has('i.icon-chevron-down').length
        $(this).removeClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right')
        $($(this).data('target')).select(':visible').hide('slow')
      else
        if $(this).has('i.icon-chevron-right').length
          $(this).addClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right')
          $($(this).data('target')).select(':hidden').show('slow')

  $('.form-horizontal legend').live 'click', ->
    if $(this).has('i.icon-chevron-down').length
      $(this).siblings('.control-group:visible').hide('slow')
      $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right')
    else
      if $(this).has('i.icon-chevron-right').length
        $(this).siblings('.control-group:hidden').show('slow')
        $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right')
    
