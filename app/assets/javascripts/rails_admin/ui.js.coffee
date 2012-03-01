$ = jQuery

$("#list input.toggle").live "click", ->
  $("#list [name='bulk_ids[]']").attr "checked", $(this).is(":checked")

$("#list a, #list form").live "ajax:complete", (xhr, data, status) ->
  $("#list").replaceWith data.responseText

$("table#history th.header[data-href]").live "click", ->
  window.location = $(this).data('href')

$('.pjax').live 'click', (event) ->
  if $.support.pjax
    event.preventDefault()
    $.pjax
      container: '[data-pjax-container]'
      url: $(this).data('href') || $(this).attr('href')
      timeout: 2000
  else if $(this).data('href') # not a native #href, need some help
    window.location = $(this).data('href')

$('.pjax-form').live 'submit', (event) ->
  if $.support.pjax
    event.preventDefault()
    $.pjax
      container: '[data-pjax-container]'
      url: this.action + (if (this.action.indexOf('?') != -1) then '&' else '?') + $(this).serialize()
      timeout: 2000

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

$(document).ready ->

  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')

  $('.form-horizontal legend').has('i.icon-chevron-right').each ->
    $(this).siblings('.control-group').hide()

  $('[rel=tooltip]').tooltip(delay: { show: 200, hide: 500 });


