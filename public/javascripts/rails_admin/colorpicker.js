
/*
   colorPicker for script.aculo.us, version 1.0
   REQUIRES prototype.js, yahoo.color.js and script.aculo.us
   written by Matthias Platzer AT knallgrau.at
   for a detailled documentation go to http://www.knallgrau.at/code/colorpicker
 */

if(!Control) var Control = {};
Control.colorPickers = [];
Control.ColorPicker = Class.create();
Control.ColorPicker.activeColorPicker;
Control.ColorPicker.CONTROL;
/**
 * ColorPicker Control allows you to open a little inline popUp HSV color chooser.
 * This control is bound to an input field, that holds a hex value.
 */
Control.ColorPicker.prototype = {
  initialize : function(field, options) {
    var colorPicker = this;
    Control.colorPickers.push(colorPicker);
    this.field = field
    console.log(this.field)
    this.fieldName = this.field.name || this.field.id;
    this.options = Object.extend({
       IMAGE_BASE : "img/"
    }, options || {});
    this.swatch = $(this.options.swatch) || this.field;
    this.rgb = {};
    this.hsv = {};
    this.isOpen = false;
    // create control (popUp) if not already existing
    // all colorPickers on a page share the same control (popUp)
    if (!Control.ColorPicker.CONTROL) {
      Control.ColorPicker.CONTROL = {};
      if (!$("colorpicker")) {
        var control = Builder.node('div', {id: 'colorpicker'});
        control.innerHTML =
          '<div id="colorpicker-div">' + (
            // apply png fix for ie 5.5 and 6.0
            (/MSIE ((6)|(5\.5))/gi.test(navigator.userAgent) && /windows/i.test(navigator.userAgent) && !/opera/i.test(navigator.userAgent)) ?
              '<img id="colorpicker-bg" src="' + this.options.IMAGE_BASE + 'blank.gif" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + this.options.IMAGE_BASE + 'pickerbg.png\', sizingMethod=\'scale\')" alt="">' :
              '<img id="colorpicker-bg" src="' + this.options.IMAGE_BASE + 'pickerbg.png" alt="">'
             ) +
          '<div id="colorpicker-bg-overlay" style="z-index: 1002;"></div>' +
          '<div id="colorpicker-selector"><img src="' + this.options.IMAGE_BASE + 'select.gif" width="11" height="11" alt="" /></div></div>' +
          '<div id="colorpicker-hue-container"><img src="' + this.options.IMAGE_BASE + 'hue.png" id="colorpicker-hue-bg-img"><div id="colorpicker-hue-slider"><div id="colorpicker-hue-thumb"><img src="' + this.options.IMAGE_BASE + 'hline.png"></div></div></div>' +
          '<div id="colorpicker-footer"><span id="colorpicker-value">#<input type="text" onclick="this.select()" id="colorpicker-value-input" name="colorpicker-value" value=""></input></span><button id="colorpicker-okbutton">OK</button></div>'
        document.body.appendChild(control);
      }
      Control.ColorPicker.CONTROL = {
        popUp : $("colorpicker"),
        pickerArea : $('colorpicker-div'),
        selector : $('colorpicker-selector'),
        okButton : $("colorpicker-okbutton"),
        value : $("colorpicker-value"),
        input : $("colorpicker-value-input"),
        picker : new Draggable($('colorpicker-selector'), {
          snap: function(x, y) {
            return [
              Math.min(Math.max(x, 0), Control.ColorPicker.activeColorPicker.control.pickerArea.offsetWidth),
              Math.min(Math.max(y, 0), Control.ColorPicker.activeColorPicker.control.pickerArea.offsetHeight)
            ];
          },
          zindex: 1009,
          change: function(draggable) {
            var pos = draggable.currentDelta();
            Control.ColorPicker.activeColorPicker.update(pos[0], pos[1]);
          }
        }),
        hueSlider: new Control.Slider('colorpicker-hue-thumb', 'colorpicker-hue-slider', {
          axis: 'vertical',
          onChange: function(v) {
            Control.ColorPicker.activeColorPicker.updateHue(v);
          }
        })
      };
      Element.hide($("colorpicker"));
    }
    this.control = Control.ColorPicker.CONTROL;

    // bind event listener to properties, so we can use them savely with Event[observe|stopObserving]
    this.toggleOnClickListener = this.toggle.bindAsEventListener(this);
    this.updateOnChangeListener = this.updateFromFieldValue.bindAsEventListener(this);
    this.closeOnClickOkListener = this.close.bindAsEventListener(this);
    this.updateOnClickPickerListener = this.updateSelector.bindAsEventListener(this);

    Event.observe(this.swatch, "click", this.toggleOnClickListener);
    Event.observe(this.field, "change", this.updateOnChangeListener);
    Event.observe(this.control.input, "change", this.updateOnChangeListener);

    this.updateSwatch();
  },
  toggle : function(event) {
    this[(this.isOpen) ? "close" : "open"](event);
    Event.stop(event);
  },
  open : function(event) {
    Control.colorPickers.each(function(colorPicker) {
      colorPicker.close();
    });
    Control.ColorPicker.activeColorPicker = this;
    this.isOpen = true;
    Element.show(this.control.popUp);
    if (this.options.getPopUpPosition) {
       var pos = this.options.getPopUpPosition.bind(this)(event);
    } else {
      var pos = Position.cumulativeOffset(this.swatch || this.field);
      pos[0] = (pos[0] + (this.swatch || this.field).offsetWidth + 10);
    }
    this.control.popUp.style.left = (pos[0]) + "px";
    this.control.popUp.style.top = (pos[1]) + "px";
    this.updateFromFieldValue();
    Event.observe(this.control.okButton, "click", this.closeOnClickOkListener);
    Event.observe(this.control.pickerArea, "mousedown", this.updateOnClickPickerListener);
    if (this.options.onOpen) this.options.onOpen.bind(this)(event);
  },
  close : function(event) {
    if (Control.ColorPicker.activeColorPicker == this) Control.ColorPicker.activeColorPicker = null;
    this.isOpen = false;
    Element.hide(this.control.popUp);
    Event.stopObserving(this.control.okButton, "click", this.closeOnClickOkListener);
    Event.stopObserving(this.control.pickerArea, "mousedown", this.updateOnClickPickerListener);
    if (this.options.onClose) this.options.onClose.bind(this)();
  },
  updateHue : function(v) {
    var h = (this.control.pickerArea.offsetHeight - v * 100) / this.control.pickerArea.offsetHeight;
    if (h == 1) h = 0;
    var rgb = YAHOO.util.Color.hsv2rgb( h, 1, 1 );
    if (!YAHOO.util.Color.isValidRGB(rgb)) return;
    this.control.pickerArea.style.backgroundColor = "rgb(" + rgb[0] + ", " + rgb[1] + ", " + rgb[2] + ")";
    this.update();
  },
  updateFromFieldValue : function(event) {
    if (!this.isOpen) return;
    var field = (event && Event.findElement(event, "input")) || this.field;
    var rgb = YAHOO.util.Color.hex2rgb( field.value );
    if (!YAHOO.util.Color.isValidRGB(rgb)) return;
    var hsv = YAHOO.util.Color.rgb2hsv( rgb[0], rgb[1], rgb[2] );
    this.control.selector.style.left = Math.round(hsv[1] * this.control.pickerArea.offsetWidth) + "px";
    this.control.selector.style.top = Math.round((1 - hsv[2]) * this.control.pickerArea.offsetWidth) + "px";
    this.control.hueSlider.setValue((1 - hsv[0]));
  },
  updateSelector : function(event) {
    var xPos = Event.pointerX(event);
    var yPos = Event.pointerY(event);
    var pos = Position.cumulativeOffset($("colorpicker-bg"));
    this.control.selector.style.left = (xPos - pos[0] - 6) + "px";
    this.control.selector.style.top = (yPos - pos[1] - 6) + "px";
    this.update((xPos - pos[0]), (yPos - pos[1]));
    this.control.picker.initDrag(event);
  },
  updateSwatch : function() {
    var rgb = YAHOO.util.Color.hex2rgb( this.field.value );
    if (!YAHOO.util.Color.isValidRGB(rgb)) return;
    this.swatch.style.backgroundColor = "rgb(" + rgb[0] + ", " + rgb[1] + ", " + rgb[2] + ")";
    var hsv = YAHOO.util.Color.rgb2hsv( rgb[0], rgb[1], rgb[2] );
    this.swatch.style.color = (hsv[2] > 0.65) ? "#000000" : "#FFFFFF";
  },
  update : function(x, y) {
    if (!x) x = this.control.picker.currentDelta()[0];
    if (!y) y = this.control.picker.currentDelta()[1];

    var h = (this.control.pickerArea.offsetHeight - this.control.hueSlider.value * 100) / this.control.pickerArea.offsetHeight;
    if (h == 1) { h = 0; };
    this.hsv = {
      hue: 1 - this.control.hueSlider.value,
      saturation: x / this.control.pickerArea.offsetWidth,
      brightness: (this.control.pickerArea.offsetHeight - y) / this.control.pickerArea.offsetHeight
    };
    var rgb = YAHOO.util.Color.hsv2rgb( this.hsv.hue, this.hsv.saturation, this.hsv.brightness );
    this.rgb = {
      red: rgb[0],
      green: rgb[1],
      blue: rgb[2]
    };
    this.field.value = YAHOO.util.Color.rgb2hex(rgb[0], rgb[1], rgb[2]);
    this.control.input.value = this.field.value;
    this.updateSwatch();
    if (this.options.onUpdate) this.options.onUpdate.bind(this)(this.field.value);
  }
}

$$('.color').each(function (el) {
  new Control.ColorPicker(el, {IMAGE_BASE: '/images/rails_admin/colorpicker/'});
});
