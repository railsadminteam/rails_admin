(->
  $ = jQuery

  setFrozenColPositions = ->
    $listForm = $('#bulk_form')
    return unless $listForm.is('.ra-horizontal-scroll-list')
    $listForm.find('table tr').each (index, tr) ->
      firstPosition = 0
      $(tr).find('.ra-horizontal-scroll-frozen').each (idx, td) ->
        tdLeft = $(td).position().left
        firstPosition = tdLeft if idx == 0
        td.style.left = "#{tdLeft - firstPosition}px"

  $(window).on('load', setFrozenColPositions) # Update after link icons load.
  $(document).on('rails_admin.dom_ready', setFrozenColPositions)
)()
