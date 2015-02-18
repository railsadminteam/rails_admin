$ ->
  (->
    $children = $('[class*="child-of"]')
    $children.each (i, child) ->
      child_classes = $(child).attr('class').split(' ')
      $(child_classes).each (i, child_class) ->
        $child_class = $('.' + child_class)
        if child_class.indexOf('child-of-') == 0
          parent_class = '.parent-' + child_class.split('-')[2]
          $parent = $(parent_class)
          $parent_container = $parent.parent('li')
          $child_class.slideUp()
          $parent_container.off('click').on 'click', (e) ->
            $(this).find('a').toggleClass('up', 0)
            $child_class.slideToggle()
            return
          $parent.addClass 'togglable'
        return
      return
    $('.chevron').not('.togglable').removeClass 'chevron'
    return
  )()
  return

