$ = jQuery

$('form').live 'nested:fieldAdded', (content) ->
  field = content.field.addClass('tab-pane');
  new_tab = $('<li><a data-toggle="tab" href="#' + field.attr('id') + '">' + field.children('.object-infos').data('object-label') + '</a></li>')
  parent_group = field.closest('.control-group')
  controls = parent_group.children('.controls')
  nav = controls.children('.nav')
  content = parent_group.children('.tab-content')
  toggler = controls.find('.toggler')
  nav.append(new_tab)
  new_tab.children('a').tab('show') # activate added tab
  nav.select(':hidden').show('slow') # show nav if hidden
  content.select(':hidden').show('slow') # show tabs content if hidden
  # toggler 'on' if inactive
  toggler.addClass('active').removeClass('disabled').children('i').addClass('icon-chevron-down').removeClass('icon-chevron-right')
  
$('form').live 'nested:fieldRemoved', (content) ->
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
