Hash.prototype.without = function() {
    var values = $A(arguments);
  var retHash = $H();
    this.each(function(entry) {
    if(!values.include(entry.key))
      retHash.set(entry.key, entry.value);
    });
  return retHash;
}

Element.insertAfter = function(insert, element) {
  if (element.nextSibling) element.parentNode.insertBefore(insert, element.nextSibling);
  else element.parentNode.appendChild(insert);
}

// Fix exceptions thrown thrown when removing an element with no parent
Element._remove = Element.remove;
Element.remove = function(element) {
  element = $(element);
  if (element.parentNode)
    return Element._remove(element);
}
