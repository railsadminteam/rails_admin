var buffer = []
document.observe("dom:loaded", function() {

  var counter = 0;

  $$(".firstSelect").each(function(elem){
    elem.writeAttribute('ref',counter);
    buffer[counter] = []

    elem.childElements().each(function(e){
      buffer[counter].push([e.innerHTML,e.readAttribute('value')])
    })

    counter += 1;
  })

  $$(".searchMany").each(function(elem){

    Event.observe(elem,'keyup',function(e){
      var select = elem.parentNode.parentNode.childElements()[2].childElements()[0];
      var aux = []
      var ref = select.readAttribute('ref')
      var text = e.target.value;

      buffer[ref].each(function(ev){
        if(ev[0].indexOf(text)!=-1){
          aux.push(ev)
        }
      })

      select.childElements().each(function(ev){
        ev.remove();
      })

      aux.each(function(ev){
        var option = new Element('option',{"value":ev[1]}).update(ev[0])
        select.insert({bottom:option});
      })

    })
  })

  $$(".addAssoc").each(function(elem){
    Event.observe(elem,'click',function(e){
      var parentDiv = e.target.parentNode.parentNode;
      var hiddenFields = parentDiv.parentNode.childElements()[4];
      var assocName = parentDiv.parentNode.childElements()[4].childElements()[0].readAttribute('name');

      var select = parentDiv.childElements()[0];
      var select_two = parentDiv.childElements()[3]
      var counter = select.readAttribute("ref");

      select.childElements().each(function(ev){
        if(ev.selected == true){

          var option = new Element('option',{"value":ev.readAttribute('value')}).update(ev.innerHTML)
          select_two.insert({bottom:option});
          ev.remove()

          var hidden = new Element('input',{"name":assocName,"type":"hidden","value":ev.readAttribute('value')})
          hiddenFields.insert({bottom:hidden});
        }

      })
      buffer[counter] = []
      select.childElements().each(function(e){
        buffer[counter].push([e.innerHTML,e.readAttribute('value')])
      })

      var hiddenElem = parentDiv.parentNode.childElements()[4].childElements()[0];
      if(!hiddenElem.value) hiddenElem.remove()
      // remakeBuffer
    })
  })

  $$(".removeAssoc").each(function(elem){
    Event.observe(elem,'click',function(e){
      var parentDiv = e.target.parentNode.parentNode;
      var select = parentDiv.childElements()[0];
      var select_two = parentDiv.childElements()[3]
      var counter = select.readAttribute("ref");

      var hiddenFields = parentDiv.parentNode.childElements()[4];
      var assocName = parentDiv.parentNode.childElements()[4].childElements()[0].readAttribute('name');

      select_two.childElements().each(function(ev){
        if(ev.selected == true){

          var option = new Element('option',{"value":ev.readAttribute('value')}).update(ev.innerHTML)
          select.insert({bottom:option});
          ev.remove()

          hiddenFields.childElements().each(function(o){
            var hiddenValue = o.value;
            if(hiddenValue==ev.readAttribute('value')){

              if(hiddenFields.childElements().size()==1){
                var hidden = new Element('input',{"name":assocName,"type":"hidden"})
                hiddenFields.insert({bottom:hidden});
              }

              o.remove()
            }
          })
        }

      })

      buffer[counter] = []
      select.childElements().each(function(e){
        buffer[counter].push([e.innerHTML,e.readAttribute('value')])
      })
      // remakeBuffer
    })
  })

  $$(".addAssoc").each(function(elem){
    Event.observe(elem,'click',function(e){

      var parentDiv = e.target.parentNode.parentNode.childElements()[2].childElements();

      var select = parentDiv[0];
      var select_two = parentDiv[3];

      select.childElements().each(function(ev){
        var option = new Element('option',{"value":ev.readAttribute('value')}).update(ev.innerHTML)
        select_two.insert({bottom:option});
        ev.remove()
      })

      var counter = select.readAttribute("ref");
      buffer[counter] = []
    })
  })

  $$(".clearAssoc").each(function(elem){
    Event.observe(elem,'click',function(e){

      var parentDiv = e.target.parentNode.parentNode.childElements()[2].childElements();

      var select = parentDiv[0];
      var select_two = parentDiv[3];

      select_two.childElements().each(function(ev){
        var option = new Element('option',{"value":ev.readAttribute('value')}).update(ev.innerHTML)
        select.insert({bottom:option});
        ev.remove()
      })

      var counter = select.readAttribute("ref");
      buffer[counter] = []
      select.childElements().each(function(e){
        buffer[counter].push([e.innerHTML,e.readAttribute('value')])
      })
    })
  })

  $$(".searchMany").each(function(elem){
    Event.observe(elem,'focus',function(e){
      var used = e.target.readAttribute('used');

      if(used=="0"){
        e.target.setStyle({color:"#000"});
        e.target.writeAttribute('used','1');
        e.target.value = ""
      }
    })

    Event.observe(elem,'blur',function(e){
      var text = e.target.value;
      var used = e.target.readAttribute('used');
      var assoc = e.target.readAttribute('ref');

      if(text.length == 0){
        e.target.setStyle({color:"#AAA"});
        e.target.writeAttribute('used','0');
        e.target.value = "Search " + assoc
      }
    })
  })

});
