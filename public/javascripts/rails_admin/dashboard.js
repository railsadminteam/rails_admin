var nameForMonths = ['January','February','March','April','May','June','July', 'August','September','October','November','December'];

var totalRef = 0;

// hardcoing colors rulz
function get_indicator(percent){
  if(percent < 33){
    return "#BCCEB6";
  }else if(percent < 67){
    return "#D2A71C";
  }else{
    return "#BF2531";
  }
}

function loadHistory(param){
  var ref = param;

  new Ajax.Request("/admin/history/slider", { method: 'post', parameters: { "ref": ref },
  onSuccess: function(transport) {

    var response = JSON.parse(transport.responseText)

    var max = response[4].history.number;

    response.each(function(e){
        if(e.history.number > max){
          max = e.history.number;
        }
    })

    var index = 0;
    var indexEx = 0;

    var effectsArray = []

    $$("#timelineSlider ul li").each(function(e){

      var monthName = response[index].history.month;
      var yearName = response[index].history.year;
      var text = nameForMonths[monthName-1] + " " + yearName

      if(response[index].history.number > 0){
        var percent = parseInt(response[index].history.number * 100 / max);
        var indicator = e.childElements()[1].childElements()[0];
        var setStyle = "height: "+percent+"%; background:"+get_indicator(percent);
      }else{
        var indicator = e.childElements()[1].childElements()[0];
        var setStyle = "height: 0%; background:0";
      }

      var morphEffect = new Effect.Morph(indicator, {
        style: setStyle, sync: true, afterSetup: function(here){
          var updatedElement = e.childElements()[0];
          updatedElement.update(text)
          indexEx++;
        }
      });

      effectsArray.push(morphEffect)

      index++;
    })

    new Effect.Parallel(effectsArray);

    totalRef = ref;

    var current_ref = parseInt(ref);
    var ref_right = current_ref+1;
    var ref_left = current_ref-1;

    $("arrowLeft").writeAttribute("ref",ref_left);
    $("arrowRight").writeAttribute("ref",ref_right);

  }})

}

function getDragSection(location){
  if(location<=161){
    return 0;
  }else if(location<=345){
    return 1;
  }else if(location<=530){
    return 2;
  }else if(location<=714){
    return 3;
  }else{
    return 4;
  }
}

var lastSection = 0;

document.observe("dom:loaded", function() {

  new Draggable('handler', {
     snap: function(x, y) {
              return[ (x < 870) ? (x > -5 ? x : -5 ) : 870,
                      -12 ];
      },
    change: function(e){

      var dragLocation = parseInt($("handler").getStyle('left'))+5;
      var section = getDragSection(dragLocation);

      if(section != lastSection){
        lastSection = section;

        new Ajax.Updater('listingHistory', '/admin/history/list', {
          parameters: { "ref": totalRef, "section" :  lastSection}
        });
      }
    }
  });

  $$("#arrowLeft").each(function(elem){

    Event.observe(elem,'click',function(e){
      var ref = elem.readAttribute('ref')
      if(ref<=0) loadHistory(ref)
    })
  })

  $$("#arrowRight").each(function(elem){

    Event.observe(elem,'click',function(e){

      var ref = elem.readAttribute('ref')
      if(ref<=0) loadHistory(ref)
    })
  })

});

