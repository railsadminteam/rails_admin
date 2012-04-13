$ = jQuery

$("#list input.toggle").live "click", ->
  $("#list [name='bulk_ids[]']").attr "checked", $(this).is(":checked")

if $.support.pjax
  $('a.pjax, th.pjax').live 'click', (event) ->
    event.preventDefault()
    $.pjax
      container: $(this).data('pjax-container') || '[data-pjax-container]'
      url: $(this).data('href') || $(this).attr('href')
  $('form.pjax button[type="submit"]').live 'click', (event) ->
    event.preventDefault()
    form = $(this).closest('form')[0]
    $.pjax
      container: $(form).data('pjax-container') || '[data-pjax-container]'
      url: form.action + (if form.action.indexOf('?') != -1 then '&' else '?') + $(this).attr('name') + "="
      data: $(form).serialize()
      type: $(form).attr('method')
else 
  if $(this).data('href') # not a native #href, need some help
    event.preventDefault()
    window.location = $(this).data('href')

$(document)
  .on 'pjax:start', ->
    $('#loading').show() # show loading..
  .on 'pjax:end', -> 
    $('#loading').hide() # hide it
  .on 'pjax:error', (pjax, xhr, textStatus, errorThrown, options) ->
    options.success(xhr.responseText, errorThrown, xhr) # handle 406 (form validation failed)
    false # disable redirect fallback
  .on 'pjax:timeout', ->
    false # disable timeout
  
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
  $(document).trigger('rails_admin.dom_ready')

$(document).live 'pjax:end', ->
  $(document).trigger('rails_admin.dom_ready')

$(document).live 'rails_admin.dom_ready', ->
  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')

  $('.form-horizontal legend').has('i.icon-chevron-right').each ->
    $(this).siblings('.control-group').hide()

  $('[rel=tooltip]').tooltip(delay: { show: 200, hide: 500 });

