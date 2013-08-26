$ = jQuery

$(document).on "click", "#list input.toggle", ->
  $("#list [name='bulk_ids[]']").prop "checked", $(this).is(":checked")

$(document).on 'click', '.pjax', (event) ->
  if event.which > 1 || event.metaKey || event.ctrlKey
    return
  else if $.support.pjax
    event.preventDefault()
    $.pjax
      container: $(this).data('pjax-container') || '[data-pjax-container]'
      url: $(this).data('href') || $(this).attr('href')
      timeout: 2000
  else if $(this).data('href') # not a native #href, need some help
    window.location = $(this).data('href')

$(document).on 'submit', '.pjax-form', (event) ->
  if $.support.pjax
    event.preventDefault()
    $.pjax
      container: $(this).data('pjax-container') || '[data-pjax-container]'
      url: this.action + (if (this.action.indexOf('?') != -1) then '&' else '?') + $(this).serialize()
      timeout: 2000

$(document)
  .on 'pjax:start', ->
    $('#loading').show()
  .on 'pjax:end', ->
    $('#loading').hide()

$(document).on 'click', '[data-target]', ->
  if !$(this).hasClass('disabled')
    if $(this).has('i.icon-chevron-down').length
      $(this).removeClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right')
      $($(this).data('target')).select(':visible').hide('slow')
    else
      if $(this).has('i.icon-chevron-right').length
        $(this).addClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right')
        $($(this).data('target')).select(':hidden').show('slow')

$(document).on 'click', '.form-horizontal legend', ->
  if $(this).has('i.icon-chevron-down').length
    $(this).siblings('.control-group:visible').hide('slow')
    $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right')
  else
    if $(this).has('i.icon-chevron-right').length
      $(this).siblings('.control-group:hidden').show('slow')
      $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right')

$(document).on 'click', 'form .tab-content .tab-pane a.remove_nested_one_fields', ->
  $(this).children('input[type="hidden"]').val($(this).hasClass('active')).
    siblings('i').toggleClass('icon-check icon-trash')

$(document).ready ->
  $(document).trigger('rails_admin.dom_ready')

$(document).on 'pjax:end', ->
  $(document).trigger('rails_admin.dom_ready')

$(document).on 'rails_admin.dom_ready', ->
  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')

  $('.form-horizontal legend').has('i.icon-chevron-right').each ->
    $(this).siblings('.control-group').hide()

  $(".table").tooltip selector: "th[rel=tooltip]"

$(document).on 'click', '#fields_to_export label input#check_all', () ->
  elems = $('#fields_to_export label input')
  if $('#fields_to_export label input#check_all').is ':checked'
    $(elems).prop('checked', true)
  else
    $(elems).prop('checked',false)
