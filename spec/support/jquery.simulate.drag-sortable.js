(function($) {
  /*
   * Simulate drag of a JQuery UI sortable list
   * Repository: https://github.com/mattheworiordan/jquery.simulate.drag-sortable.js
   * Author: http://mattheworiordan.com
   *
   * options are:
   * - move: move item up (positive) or down (negative) by Integer amount
   * - dropOn: move item to a new linked list, move option now represents position in the new list (zero indexed)
   * - handle: selector for the draggable handle element (optional)
   * - listItem: selector to limit which sibling items can be used for reordering
   * - placeHolder: if a placeholder is used during dragging, we need to consider it's height
   * - tolerance: (optional) number of pixels to overlap by instead of the default 50% of the element height
   *
   */
  $.fn.simulateDragSortable = function(options) {
    // build main options before element iteration
    var opts = $.extend({}, $.fn.simulateDragSortable.defaults, options);

    applyDrag = function(options) {
      // allow for a drag handle if item is not draggable
      var that = this,
          options = options || opts, // default to plugin opts unless options explicitly provided
          handle = options.handle ? $(this).find(options.handle)[0] : $(this)[0],
          listItem = options.listItem,
          placeHolder = options.placeHolder,
          sibling = $(this),
          moveCounter = Math.floor(options.move),
          direction = moveCounter > 0 ? 'down' : 'up',
          moveVerticalAmount = 0,
          initialVerticalPosition = 0,
          extraDrag = !isNaN(parseInt(options.tolerance, 10)) ? function() { return Number(options.tolerance); } : function(obj) { return ($(obj).outerHeight() / 2) + 5; },
          dragPastBy = 0, // represents the additional amount one drags past an element and bounce back
          dropOn = options.dropOn ? $(options.dropOn) : false,
          center = findCenter(handle),
          x = Math.floor(center.x),
          y = Math.floor(center.y),
          mouseUpAfter = (opts.debug ? 2500 : 10);

      if (dropOn) {
        if (dropOn.length === 0) {
          if (console && console.log) { console.log('simulate.drag-sortable.js ERROR: Drop on target could not be found'); console.log(options.dropOn); }
          return;
        }
        sibling = dropOn.find('>*:last');
        moveCounter = -(dropOn.find('>*').length + 1) + (moveCounter + 1); // calculate length of list after this move, use moveCounter as a positive index position in list to reverse back up
        if (dropOn.offset().top - $(this).offset().top < 0) {
          // moving to a list above this list, so move to just above top of last item (tried moving to top but JQuery UI wouldn't bite)
          initialVerticalPosition = sibling.offset().top - $(this).offset().top - extraDrag(this);
        } else {
          // moving to a list below this list, so move to bottom and work up (JQuery UI does not trigger new list below unless you move past top item first)
          initialVerticalPosition = sibling.offset().top - $(this).offset().top - $(this).height();
        }
      } else if (moveCounter === 0) {
        if (console && console.log) { console.log('simulate.drag-sortable.js WARNING: Drag with move set to zero has no effect'); }
        return;
      } else {
        while (moveCounter !== 0) {
          if (direction === 'down') {
            if (sibling.next(listItem).length) {
              sibling = sibling.next(listItem);
              moveVerticalAmount += sibling.outerHeight();
            }
            moveCounter -= 1;
          } else {
            if (sibling.prev(listItem).length) {
              sibling = sibling.prev(listItem);
              moveVerticalAmount -= sibling.outerHeight();
            }
            moveCounter += 1;
          }
        }
      }

      dispatchEvent(handle, 'mousedown', createEvent('mousedown', handle, { clientX: x, clientY: y }));
      // simulate drag start
      dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x+1, clientY: y+1 }));

      if (dropOn) {
        // jump to top or bottom of new list but do it in increments so that JQuery UI registers the drag events
        slideUpTo(x, y, initialVerticalPosition);

        // reset y position to top or bottom of list and move from there
        y += initialVerticalPosition;

        // now call regular shift/down in a list
        options = jQuery.extend(options, { move: moveCounter });
        delete options.dropOn;

        // add some delays to allow JQuery UI to catch up
        setTimeout(function() {
          dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y }));
        }, 5);
        setTimeout(function() {
          dispatchEvent(handle, 'mouseup', createEvent('mouseup', handle, { clientX: x, clientY: y }));
          setTimeout(function() {
            if (options.move) {
              applyDrag.call(that, options);
            }
          }, 5);
        }, mouseUpAfter);

        // stop execution as applyDrag has been called again
        return;
      }

      // Sortable is using a fixed height placeholder meaning items jump up and down as you drag variable height items into fixed height placeholder
      placeHolder = placeHolder && $(this).parent().find(placeHolder);

      if (!placeHolder && (direction === 'down')) {
        // need to move at least as far as this item and or the last sibling
        if ($(this).outerHeight() > $(sibling).outerHeight()) {
          moveVerticalAmount += $(this).outerHeight() - $(sibling).outerHeight();
        }
        moveVerticalAmount += extraDrag(sibling);
        dragPastBy += extraDrag(sibling);
      } else if (direction === 'up') {
        // move a little extra to ensure item clips into next position
        moveVerticalAmount -= Math.max(extraDrag(this), 5);
      } else if (direction === 'down') {
        // moving down with a place holder
        if (placeHolder.height() < $(this).height()) {
          moveVerticalAmount += Math.max(placeHolder.height(), 5);
        } else {
          moveVerticalAmount += extraDrag(sibling);
        }
      }

      if (sibling[0] !== $(this)[0]) {
        // step through so that the UI controller can determine when to show the placeHolder
        slideUpTo(x, y, moveVerticalAmount, dragPastBy);
      } else {
        if (window.console) {
          console.log('simulate.drag-sortable.js WARNING: Could not move as at top or bottom already');
        }
      }

      setTimeout(function() {
        dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y + moveVerticalAmount }));
      }, 5);
      setTimeout(function() {
        dispatchEvent(handle, 'mouseup', createEvent('mouseup', handle, { clientX: x, clientY: y + moveVerticalAmount }));
      }, mouseUpAfter);
    };

    // iterate and move each matched element
    return this.each(applyDrag);
  };

  // fire mouse events, go half way, then the next half, so small mouse movements near target and big at the start
  function slideUpTo(x, y, targetOffset, goPastBy) {
    var moveBy, offset;

    if (!goPastBy) { goPastBy = 0; }
    if ((targetOffset < 0) && (goPastBy > 0)) { goPastBy = -goPastBy; } // ensure go past is in the direction as often passed in from object height so always positive

    // go forwards including goPastBy
    for (offset = 0; Math.abs(offset) + 1 < Math.abs(targetOffset + goPastBy); offset += ((targetOffset + goPastBy - offset)/2) ) {
      dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y + Math.ceil(offset) }));
    }
    offset = targetOffset + goPastBy;
    dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y + offset }));

    // now bounce back
    for (; Math.abs(offset) - 1 >= Math.abs(targetOffset); offset += ((targetOffset - offset)/2) ) {
      dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y + Math.ceil(offset) }));
    }
    dispatchEvent(document, 'mousemove', createEvent('mousemove', document, { clientX: x, clientY: y + targetOffset }));
  }

  function createEvent(type, target, options) {
    var evt;
    var e = $.extend({
      target: target,
      preventDefault: function() { },
      stopImmediatePropagation: function() { },
      stopPropagation: function() { },
      isPropagationStopped: function() { return true; },
      isImmediatePropagationStopped: function() { return true; },
      isDefaultPrevented: function() { return true; },
      bubbles: true,
      cancelable: (type != "mousemove"),
      view: window,
      detail: 0,
      screenX: 0,
      screenY: 0,
      clientX: 0,
      clientY: 0,
      ctrlKey: false,
      altKey: false,
      shiftKey: false,
      metaKey: false,
      button: 0,
      relatedTarget: undefined
    }, options || {});

    if ($.isFunction(document.createEvent)) {
      evt = document.createEvent("MouseEvents");
      evt.initMouseEvent(type, e.bubbles, e.cancelable, e.view, e.detail,
        e.screenX, e.screenY, e.clientX, e.clientY,
        e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
        e.button, e.relatedTarget || document.body.parentNode);
    } else if (document.createEventObject) {
      evt = document.createEventObject();
      $.extend(evt, e);
        evt.button = { 0:1, 1:4, 2:2 }[evt.button] || evt.button;
    }
    return evt;
  }

  function dispatchEvent(el, type, evt) {
    if (el.dispatchEvent) {
      el.dispatchEvent(evt);
    } else if (el.fireEvent) {
      el.fireEvent('on' + type, evt);
    }
    return evt;
  }

  function findCenter(el) {
    var elm = $(el),
        o = elm.offset();
    return {
      x: o.left + elm.outerWidth() / 2,
      y: o.top + elm.outerHeight() / 2
    };
  }

  //
  // plugin defaults
  //
  $.fn.simulateDragSortable.defaults = {
    move: 0
  };
})(jQuery);