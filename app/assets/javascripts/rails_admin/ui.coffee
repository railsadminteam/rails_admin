$ = jQuery

$(document).on "click", "#list input.toggle", ->
  $("#list [name='bulk_ids[]']").prop "checked", $(this).is(":checked")

$(document).on 'click', (event) ->
  if event.which > 1 || event.metaKey || event.ctrlKey
    return
  else if $(this).data('href') # not a native #href, need some help
    window.location = $(this).data('href')

$(document).on 'click', '[data-target]', ->
  if !$(this).hasClass('disabled')
    if $(this).has('i.ion-chevron-down').length
      $(this).removeClass('active').children('i').toggleClass('ion-chevron-down ion-chevron-right')
      $($(this).data('target')).select(':visible').hide('slow')
    else
      if $(this).has('i.ion-chevron-right').length
        $(this).addClass('active').children('i').toggleClass('ion-chevron-down ion-chevron-right')
        $($(this).data('target')).select(':hidden').show('slow')

$(document).on 'click', '.form-horizontal legend', ->
  if $(this).has('i.ion-chevron-down').length
    $(this).siblings('.form-group:visible').hide('slow')
    $(this).children('i').toggleClass('ion-chevron-down ion-chevron-right')
  else
    if $(this).has('i.ion-chevron-right').length
      $(this).siblings('.form-group:hidden').show('slow')
      $(this).children('i').toggleClass('ion-chevron-down ion-chevron-right')

$(document).on 'click', 'form .tab-content .tab-pane a.remove_nested_one_fields', ->
  $(this).children('input[type="hidden"]').val($(this).hasClass('active')).
    siblings('i').toggleClass('ion-checkmark ion-trash-a')

$(document).ready ->
  $(document).trigger('rails_admin.dom_ready')

$(document).on 'rails_admin.dom_ready', ->
  $('.animate-width-to').each ->
    length = $(this).data("animate-length")
    width = $(this).data("animate-width-to")
    $(this).animate(width: width, length, 'easeOutQuad')

  $('.form-horizontal legend').has('i.ion-chevron-right').each ->
    $(this).siblings('.form-group').hide()

$(document).on 'click', '#fields_to_export label input#check_all', () ->
  elems = $('#fields_to_export label input')
  if $('#fields_to_export label input#check_all').is ':checked'
    $(elems).prop('checked', true)
  else
    $(elems).prop('checked',false)
