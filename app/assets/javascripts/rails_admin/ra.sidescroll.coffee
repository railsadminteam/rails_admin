(->
  $ = jQuery

  setFrozenColPositions = ->
    $listForm = $('#bulk_form')
    return unless $listForm.is('.ra-sidescroll')
    frozenColumns = $listForm.data('ra-sidescroll')
    $listForm.find('table tr').each (index, tr) ->
      firstPosition = 0
      $(tr).children().slice(0, frozenColumns).each (idx, td) ->
        $(td).addClass('ra-sidescroll-frozen')
        $(td).addClass('last-of-frozen') if idx == frozenColumns - 1
        tdLeft = $(td).position().left
        firstPosition = tdLeft if idx == 0
        td.style.left = "#{tdLeft - firstPosition}px"

  $(window).on('load', setFrozenColPositions) # Update after link icons load.
  $(document).on('rails_admin.dom_ready', setFrozenColPositions)
)()
