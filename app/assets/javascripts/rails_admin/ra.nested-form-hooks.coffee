$ = jQuery

$(document).ready ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    tab_content = $(link).closest(".controls").siblings(".tab-content")
    tab_content.append content
    tab_content.children().last()

$(document).on 'nested:fieldAdded', 'form', (content) ->
  field = content.field.addClass('tab-pane').attr('id', 'unique-id-' + (new Date().getTime()))
  new_tab = $('<li><a data-toggle="tab" href="#' + field.attr('id') + '">' + field.children('.object-infos').data('object-label') + '</a></li>')
  parent_group = field.closest('.control-group')
  controls = parent_group.children('.controls')
  nav = controls.children('.nav')
  content = parent_group.children('.tab-content')
  toggler = controls.find('.toggler')
  nav.append(new_tab)
  $(window.document).trigger('rails_admin.dom_ready') # fire dom_ready for new player in town
  new_tab.children('a').tab('show') # activate added tab
  nav.select(':hidden').show('slow') # show nav if hidden
  content.select(':hidden').show('slow') # show tabs content if hidden
  # toggler 'on' if inactive
  toggler.addClass('active').removeClass('disabled').children('i').addClass('icon-chevron-down').removeClass('icon-chevron-right')

$(document).on 'nested:fieldRemoved', 'form', (content) ->
  field = content.field
  nav = field.closest(".control-group").children('.controls').children('.nav')
  current_li = nav.children('li').has('a[href=#' + field.attr('id') + ']')
  parent_group = field.closest(".control-group")
  controls = parent_group.children('.controls')
  toggler = controls.find('.toggler')

  # try to activate another tab
  (if current_li.next().length then current_li.next() else current_li.prev()).children('a:first').tab('show')

  current_li.remove()

  if nav.children().length == 0 # removed last tab
    nav.select(':visible').hide('slow') # hide nav. No use anymore.
    # toggler 'off' if active
    toggler.removeClass('active').addClass('disabled').children('i').removeClass('icon-chevron-down').addClass('icon-chevron-right')
