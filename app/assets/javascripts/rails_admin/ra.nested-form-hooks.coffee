$ = jQuery

$('form').live 'nested:fieldAdded', (content) ->
  field = content.field.addClass('tab-pane');
  new_tab = $('<li><a data-toggle="tab" href="#' + field.attr('id') + '">' + field.children('.objects_infos').data('object-label') + '</a></li>');
  parent_group = field.closest(".control-group");
  parent_group.children('.tab-content').append(field)
  nav = parent_group.children('.controls').children('.nav')
  nav.append(new_tab)
  new_tab.children('a').tab('show')
  nav.show('slow') if nav.children().length == 1

$('form').live 'nested:fieldRemoved', (content) ->
  field = content.field
  nav = field.closest(".control-group").children('.controls').children('.nav')
  current_li = nav.children('li').has('a[href=#' + field.attr('id') + ']')
  (if current_li.next().length then current_li.next() else current_li.prev()).children('a:first').tab('show')
  current_li.remove()
  nav.hide('slow') if nav.children().length == 0