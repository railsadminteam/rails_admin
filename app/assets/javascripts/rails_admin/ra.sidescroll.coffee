(->
  $ = jQuery

  setFrozenColPositions = ->
    $listForm = $('#bulk_form')
    return unless $listForm.is('.ra-sidescroll')
    $listForm.find('table tr').each (index, tr) ->
      firstPosition = 0
      $(tr).find('.ra-sidescroll-frozen').each (idx, td) ->
        tdLeft = $(td).position().left
        firstPosition = tdLeft if idx == 0
        td.style.left = "#{tdLeft - firstPosition}px"

  $(window).on('load', setFrozenColPositions) # Update after link icons load.
  $(document).on('rails_admin.dom_ready', setFrozenColPositions)
)()
