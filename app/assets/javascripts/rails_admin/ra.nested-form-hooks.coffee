$ = jQuery

$(document).ready ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    tab_content = $(link).closest(".controls").siblings(".tab-content")
    tab_content.append content
    tab_content.children().last()

$(document).on 'nested:fieldAdded', 'form', (content) ->
  field = content.field.addClass('tab-pane').attr('id', 'unique-id-' + (new Date().getTime()))
  new_tab = $('<li><a data-toggle="tab" href="#' + field.attr('id') + '">' + field.children('.object-infos').data('object-label') + '</a></li>')
  new_tab = $('<li></li>').append(
    $('<a></a>').attr('data-toggle', 'tab').attr('href', '#' + field.attr('id')).text(field.children('.object-infos').data('object-label'))
  )
  parent_group = field.closest('.control-group')
  controls = parent_group.children('.controls')
  one_to_one = controls.data('nestedone') != undefined
  nav = controls.children('.nav')
  content = parent_group.children('.tab-content')
  toggler = controls.find('.toggler')
  nav.append(new_tab)
  $(window.document).trigger('rails_admin.dom_ready', [field, parent_group]) # fire dom_ready for new player in town
  new_tab.children('a').tab('show') # activate added tab
  nav.select(':hidden').show('slow') unless one_to_one # show nav if hidden
  content.select(':hidden').show('slow') # show tabs content if hidden
  # toggler 'on' if inactive
  toggler.addClass('active').removeClass('disabled').children('i').addClass('icon-chevron-down').removeClass('icon-chevron-right')

  # Convert the "add nested field" button to just showing the title of the new model
  controls.find('.add_nested_fields').removeClass('add_nested_fields').text(field.children('.object-infos').data('object-label')) if one_to_one

$(document).on 'nested:fieldRemoved', 'form', (content) ->
  field = content.field
  nav = field.closest(".control-group").children('.controls').children('.nav')
  current_li = nav.children('li').has('a[href="#' + field.attr('id') + '"]')
  parent_group = field.closest(".control-group")
  controls = parent_group.children('.controls')
  one_to_one = controls.data('nestedone') != undefined
  toggler = controls.find('.toggler')

  # try to activate another tab
  (if current_li.next().length then current_li.next() else current_li.prev()).children('a:first').tab('show')

  current_li.remove()

  if nav.children().length == 0 # removed last tab
    nav.select(':visible').hide('slow') # hide nav. No use anymore.
    # toggler 'off' if active
    toggler.removeClass('active').addClass('disabled').children('i').removeClass('icon-chevron-down').addClass('icon-chevron-right')

  if one_to_one
    # Converts the title button to an "add nested field" button
    add_button = toggler.next()
    add_button.addClass('add_nested_fields').html(add_button.data('add-label'))

  # Removing all required attributes from deleted child form to bypass browser validations.
  field.find('[required]').each ->
    $(this).removeAttr('required')
