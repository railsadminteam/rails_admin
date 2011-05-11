/*
 * jQuery UI Timepicker 0.0.8
 *
 * Copyright 2010-2011, Francois Gelinas
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://fgelinas.com
 *
 * Depends:
 *	jquery.ui.core.js
 */

 /*
  * As it is a timepicker, I inspired most of the code from the datepicker
  * Francois Gelinas - Nov 2010
  *
  * Release 0.0.2 - Jan 6, 2011
  * Updated to include common display options for USA users
  * Stephen Commisso - Jan 2011
  *
  * release 0.0.3 - Jan 8, 2011
  * Re-added a display:none on the main div (fix a small empty div visible at the bottom of the page before timepicker is called) (Thanks Gertjan van Roekel)
  * Fixed a problem where the timepicker was never displayed with jquery ui 1.8.7 css,
  *     the problem was the class ui-helper-hidden-accessible, witch I removed.
  *     Thanks Alexander Fietz and StackOverflow : http://stackoverflow.com/questions/4522274/jquery-timepicker-and-jqueryui-1-8-7-conflict
  *
  * Release 0.0.4 - jan 10, 2011
  * changed showLeadingZero to affect only hours, added showMinutesLeadingZero for minutes display
  * Removed width:100% for tables in css
  *
  * Release 0.0.5 - Jan 18, 2011
  * Now updating time picker selected value when manually typing in the text field (thanks Rasmus Schultz)
  * Fixed : with showPeriod: true and showLeadingZero: true, PM hours did not show leading zeros (thanks Chandler May)
  * Fixed : with showPeriod: true and showLeadingZero: true, Selecting 12 AM shows as 00 AM in the input field, also parsing 12AM did not work correctly (thanks Rasmus Schultz)
  *
  * Release 0.0.6 - Jan 19, 2011
  * Added standard "change" event being triggered on the input when the content changes. (Thanks Rasmus Schultz)
  * Added support for inline timePicker, attached to div or span
  * Added altField that receive the parsed time value when selected time changes
  * Added defaultTime value to use when input field is missing (inline) or input value is empty
  *       if defaultTime is missing, current time is used
  *
  * Release 0.0.7 - Fev 10, 2011
  * Added function to set time after initialisation :$('#timepicker').timepicker('setTime',newTime);
  * Added support for disabled period of time : onHourShow and onMinuteShow (thanks Rene Felgenträger)
  *
  * Release 0.0.8 - Fev 17, 2011
  * Fixed close event not triggered when switching to another input with time picker (thanks Stuart Gregg)
  *
  */

(function ($, undefined) {

    $.extend($.ui, { timepicker: { version: "0.0.8"} });

    var PROP_NAME = 'timepicker';
    var tpuuid = new Date().getTime();

    /* Time picker manager.
    Use the singleton instance of this class, $.timepicker, to interact with the time picker.
    Settings for (groups of) time pickers are maintained in an instance object,
    allowing multiple different settings on the same page. */

    function Timepicker() {
        this.debug = true; // Change this to true to start debugging
        this._curInst = null; // The current instance in use
        this._isInline = false; // true if the instance is displayed inline
        this._disabledInputs = []; // List of time picker inputs that have been disabled
        this._timepickerShowing = false; // True if the popup picker is showing , false if not
        this._inDialog = false; // True if showing within a "dialog", false if not
        this._dialogClass = 'ui-timepicker-dialog'; // The name of the dialog marker class
        this._mainDivId = 'ui-timepicker-div'; // The ID of the main timepicker division
        this._inlineClass = 'ui-timepicker-inline'; // The name of the inline marker class
        this._currentClass = 'ui-timepicker-current'; // The name of the current hour / minutes marker class
        this._dayOverClass = 'ui-timepicker-days-cell-over'; // The name of the day hover marker class

        this.regional = []; // Available regional settings, indexed by language code
        this.regional[''] = { // Default regional settings
            hourText: 'Hour', // Display text for hours section
            minuteText: 'Minute', // Display text for minutes link
            amPmText: ['AM', 'PM'] // Display text for AM PM
        };
        this._defaults = { // Global defaults for all the time picker instances
            showOn: 'focus',    // 'focus' for popup on focus,
                                // 'button' for trigger button, or 'both' for either (not yet implemented)
            showAnim: 'fadeIn',             // Name of jQuery animation for popup
            showOptions: {},                // Options for enhanced animations
            appendText: '',                 // Display text following the input box, e.g. showing the format
            onSelect: null,                 // Define a callback function when a hour / minutes is selected
            onClose: null,                  // Define a callback function when the timepicker is closed
            timeSeparator: ':',             // The caracter to use to separate hours and minutes.
            showPeriod: false,              // Define whether or not to show AM/PM with selected time
            showLeadingZero: true,          // Define whether or not to show a leading zero for hours < 10. [true/false]
            showMinutesLeadingZero: true,   // Define whether or not to show a leading zero for minutes < 10.
            altField: '',                   // Selector for an alternate field to store selected time into
            defaultTime: '',                // Used as default time when input field is empty or for inline timePicker
            
            //NEW: 2011-02-03
            onHourShow: null,			    // callback for enabling / disabling on selectable hours  ex : function(hour) { return true; }
            onMinuteShow: null              // callback for enabling / disabling on time selection  ex : function(hour,minute) { return true; }
        };
        $.extend(this._defaults, this.regional['']);

        this.tpDiv = $('<div id="' + this._mainDivId + '" class="ui-timepicker ui-widget ui-helper-clearfix ui-corner-all " style="display: none"></div>');
    }

    $.extend(Timepicker.prototype, {
        /* Class name added to elements to indicate already configured with a time picker. */
        markerClassName: 'hasTimepicker',

        /* Debug logging (if enabled). */
        log: function () {
            if (this.debug)
                console.log.apply('', arguments);
        },

        // TODO rename to "widget" when switching to widget factory
        _widgetTimepicker: function () {
            return this.tpDiv;
        },

        /* Override the default settings for all instances of the time picker.
        @param  settings  object - the new settings to use as defaults (anonymous object)
        @return the manager object */
        setDefaults: function (settings) {
            extendRemove(this._defaults, settings || {});
            return this;
        },

        /* Attach the time picker to a jQuery selection.
        @param  target    element - the target input field or division or span
        @param  settings  object - the new settings to use for this time picker instance (anonymous) */
        _attachTimepicker: function (target, settings) {
            // check for settings on the control itself - in namespace 'time:'
            var inlineSettings = null;
            for (var attrName in this._defaults) {
                var attrValue = target.getAttribute('time:' + attrName);
                if (attrValue) {
                    inlineSettings = inlineSettings || {};
                    try {
                        inlineSettings[attrName] = eval(attrValue);
                    } catch (err) {
                        inlineSettings[attrName] = attrValue;
                    }
                }
            }
            var nodeName = target.nodeName.toLowerCase();
            var inline = (nodeName == 'div' || nodeName == 'span');

            if (!target.id) {
                this.uuid += 1;
                target.id = 'tp' + this.uuid;
            }
            var inst = this._newInst($(target), inline);
            inst.settings = $.extend({}, settings || {}, inlineSettings || {});
            if (nodeName == 'input') {
                this._connectTimepicker(target, inst);
            } else if (inline) {
                this._inlineTimepicker(target, inst);
            }
        },

        /* Create a new instance object. */
        _newInst: function (target, inline) {
            var id = target[0].id.replace(/([^A-Za-z0-9_-])/g, '\\\\$1'); // escape jQuery meta chars
            return { id: id, input: target, // associated target
                selectedDay: 0, selectedMonth: 0, selectedYear: 0, // current selection
                drawMonth: 0, drawYear: 0, // month being drawn
                inline: inline, // is timepicker inline or not : 
                tpDiv: (!inline ? this.tpDiv : // presentation div
                    $('<div class="' + this._inlineClass + ' ui-timepicker ui-widget  ui-helper-clearfix"></div>'))
            };
        },

        /* Attach the time picker to an input field. */
        _connectTimepicker: function (target, inst) {
            var input = $(target);
            inst.append = $([]);
            inst.trigger = $([]);
            if (input.hasClass(this.markerClassName)) { return; }
            this._attachments(input, inst);
            input.addClass(this.markerClassName).
                keydown(this._doKeyDown).
                keyup(this._doKeyUp).
                bind("setData.timepicker", function (event, key, value) {
                    inst.settings[key] = value;
                }).
                bind("getData.timepicker", function (event, key) {
                    return this._get(inst, key);
                });
            //this._autoSize(inst);
            $.data(target, PROP_NAME, inst);
        },

        /* Handle keystrokes. */
        _doKeyDown: function (event) {
            var inst = $.timepicker._getInst(event.target);
            var handled = true;
            inst._keyEvent = true;
            if ($.timepicker._timepickerShowing) {
                switch (event.keyCode) {
                    case 9: $.timepicker._hideTimepicker();
                        handled = false;
                        break; // hide on tab out
                    case 27: $.timepicker._hideTimepicker();
                        break; // hide on escape
                    default: handled = false;
                }
            }
            else if (event.keyCode == 36 && event.ctrlKey) { // display the time picker on ctrl+home
                $.timepicker._showTimepicker(this);
            }
            else {
                handled = false;
            }
            if (handled) {
                event.preventDefault();
                event.stopPropagation();
            }
        },

        /* Update selected time on keyUp */
        /* Added verion 0.0.5 */
        _doKeyUp: function (event) {
            var inst = $.timepicker._getInst(event.target);
            $.timepicker._setTimeFromField(inst);
            $.timepicker._updateTimepicker(inst);
        },

        /* Make attachments based on settings. */
        _attachments: function (input, inst) {
            var appendText = this._get(inst, 'appendText');
            var isRTL = this._get(inst, 'isRTL');
            if (inst.append) { inst.append.remove(); }
            if (appendText) {
                inst.append = $('<span class="' + this._appendClass + '">' + appendText + '</span>');
                input[isRTL ? 'before' : 'after'](inst.append);
            }
            input.unbind('focus', this._showTimepicker);
            if (inst.trigger) { inst.trigger.remove(); }
            var showOn = this._get(inst, 'showOn');
            if (showOn == 'focus' || showOn == 'both') { // pop-up time picker when in the marked field
                input.focus(this._showTimepicker);
            }
            if (showOn == 'button' || showOn == 'both') { // pop-up time picker when button clicked
                var buttonText = this._get(inst, 'buttonText');
                var buttonImage = this._get(inst, 'buttonImage');
                inst.trigger = $(this._get(inst, 'buttonImageOnly') ?
				$('<img/>').addClass(this._triggerClass).
					attr({ src: buttonImage, alt: buttonText, title: buttonText }) :
				$('<button type="button"></button>').addClass(this._triggerClass).
					html(buttonImage == '' ? buttonText : $('<img/>').attr(
					{ src: buttonImage, alt: buttonText, title: buttonText })));
                input[isRTL ? 'before' : 'after'](inst.trigger);
                inst.trigger.click(function () {
                    if ($.timepicker._timepickerShowing && $.timepicker._lastInput == input[0]) { $.timepicker._hideTimepicker(); }
                    else { $.timepicker._showTimepicker(input[0]); }
                    return false;
                });
            }
        },


        /* Attach an inline time picker to a div. */
        _inlineTimepicker: function(target, inst) {
            var divSpan = $(target);
            if (divSpan.hasClass(this.markerClassName))
                return;
            divSpan.addClass(this.markerClassName).append(inst.tpDiv).
                bind("setData.timepicker", function(event, key, value){
                    inst.settings[key] = value;
                }).bind("getData.timepicker", function(event, key){
                    return this._get(inst, key);
                });
            $.data(target, PROP_NAME, inst);

            this._setTimeFromField(inst);
            this._updateTimepicker(inst);
            inst.tpDiv.show();
        },

        /* Pop-up the time picker for a given input field.
        @param  input  element - the input field attached to the time picker or
        event - if triggered by focus */
        _showTimepicker: function (input) {


            input = input.target || input;
            if (input.nodeName.toLowerCase() != 'input') { input = $('input', input.parentNode)[0]; } // find from button/image trigger
            if ($.timepicker._isDisabledTimepicker(input) || $.timepicker._lastInput == input) { return; } // already here

            // fix v 0.0.8 - close current timepicker before showing another one
            $.timepicker._hideTimepicker();

            var inst = $.timepicker._getInst(input);
            if ($.timepicker._curInst && $.timepicker._curInst != inst) {
                $.timepicker._curInst.tpDiv.stop(true, true);
            }
            var beforeShow = $.timepicker._get(inst, 'beforeShow');
            extendRemove(inst.settings, (beforeShow ? beforeShow.apply(input, [input, inst]) : {}));
            inst.lastVal = null;
            $.timepicker._lastInput = input;

            $.timepicker._setTimeFromField(inst);
            if ($.timepicker._inDialog) { input.value = ''; } // hide cursor
            if (!$.timepicker._pos) { // position below input
                $.timepicker._pos = $.timepicker._findPos(input);
                $.timepicker._pos[1] += input.offsetHeight; // add the height
            }
            var isFixed = false;
            $(input).parents().each(function () {
                isFixed |= $(this).css('position') == 'fixed';
                return !isFixed;
            });
            if (isFixed && $.browser.opera) { // correction for Opera when fixed and scrolled
                $.timepicker._pos[0] -= document.documentElement.scrollLeft;
                $.timepicker._pos[1] -= document.documentElement.scrollTop;
            }
            var offset = { left: $.timepicker._pos[0], top: $.timepicker._pos[1] };
            $.timepicker._pos = null;
            // determine sizing offscreen
            inst.tpDiv.css({ position: 'absolute', display: 'block', top: '-1000px' });
            $.timepicker._updateTimepicker(inst);

            // reset clicked state
            inst._hoursClicked = false;
            inst._minutesClicked = false;

            // fix width for dynamic number of time pickers
            // and adjust position before showing
            offset = $.timepicker._checkOffset(inst, offset, isFixed);
            inst.tpDiv.css({ position: ($.timepicker._inDialog && $.blockUI ?
			'static' : (isFixed ? 'fixed' : 'absolute')), display: 'none',
                left: offset.left + 'px', top: offset.top + 'px'
            });
            if (!inst.inline) {
                var showAnim = $.timepicker._get(inst, 'showAnim');
                var duration = $.timepicker._get(inst, 'duration');
                var postProcess = function () {
                    $.timepicker._timepickerShowing = true;
                    var borders = $.timepicker._getBorders(inst.tpDiv);
                    inst.tpDiv.find('iframe.ui-timepicker-cover'). // IE6- only
					css({ left: -borders[0], top: -borders[1],
					    width: inst.tpDiv.outerWidth(), height: inst.tpDiv.outerHeight()
					});
                };
                inst.tpDiv.zIndex($(input).zIndex() + 1);
                if ($.effects && $.effects[showAnim]) {
                    inst.tpDiv.show(showAnim, $.timepicker._get(inst, 'showOptions'), duration, postProcess);
                }
                else {
                    inst.tpDiv[showAnim || 'show']((showAnim ? duration : null), postProcess);
                }
                if (!showAnim || !duration) { postProcess(); }
                if (inst.input.is(':visible') && !inst.input.is(':disabled')) { inst.input.focus(); }
                $.timepicker._curInst = inst;
            }
        },

        /* Generate the time picker content. */
        _updateTimepicker: function (inst) {
            var self = this;
            var borders = $.timepicker._getBorders(inst.tpDiv);
            inst.tpDiv.empty().append(this._generateHTML(inst))
			.find('iframe.ui-timepicker-cover') // IE6- only
				.css({ left: -borders[0], top: -borders[1],
				    width: inst.tpDiv.outerWidth(), height: inst.tpDiv.outerHeight()
				})
			.end()
			.find('.ui-timepicker td a')
				.bind('mouseout', function () {
				    $(this).removeClass('ui-state-hover');
				    if (this.className.indexOf('ui-timepicker-prev') != -1) $(this).removeClass('ui-timepicker-prev-hover');
				    if (this.className.indexOf('ui-timepicker-next') != -1) $(this).removeClass('ui-timepicker-next-hover');
				})
				.bind('mouseover', function () {
				    if (!self._isDisabledTimepicker(inst.inline ? inst.tpDiv.parent()[0] : inst.input[0])) {
				        $(this).parents('.ui-timepicker-calendar').find('a').removeClass('ui-state-hover');
				        $(this).addClass('ui-state-hover');
				        if (this.className.indexOf('ui-timepicker-prev') != -1) $(this).addClass('ui-timepicker-prev-hover');
				        if (this.className.indexOf('ui-timepicker-next') != -1) $(this).addClass('ui-timepicker-next-hover');
				    }
				})
			.end()
			.find('.' + this._dayOverClass + ' a')
				.trigger('mouseover')
			.end();
        },

        /* Generate the HTML for the current state of the date picker. */
        _generateHTML: function (inst) {
            var h, m, html = '';
            var showPeriod = (this._get(inst, 'showPeriod') == true);
            var showLeadingZero = (this._get(inst, 'showLeadingZero') == true);

            var amPmText = this._get(inst, 'amPmText');


            html = '<table class="ui-timepicker-table ui-widget-content ui-corner-all"><tr>' +
                   '<td class="ui-timepicker-hours">' +
                   '<div class="ui-timepicker-title ui-widget-header ui-helper-clearfix ui-corner-all">' +
                   this._get(inst, 'hourText') + 
                   '</div>' +
                   '<table class="ui-timepicker">';

            // AM
            html += '<tr><th rowspan="2" class="periods">' + amPmText[0] + '</th>';
            for (h = 0; h <= 5; h++) {
                html += this._generateHTMLHourCell(inst, h, showPeriod, showLeadingZero);
            }

            html += '</tr><tr>';
            for (h = 6; h <= 11; h++) {
                html += this._generateHTMLHourCell(inst, h, showPeriod, showLeadingZero);
            }

            // PM
            html += '</tr><tr><th rowspan="2" class="periods">' + amPmText[1] + '</th>';
            for (h = 12; h <= 17; h++) {
                html += this._generateHTMLHourCell(inst, h, showPeriod, showLeadingZero);
            }

            html += '</tr><tr>';
            for (h = 18; h <= 23; h++) {
                html += this._generateHTMLHourCell(inst, h, showPeriod, showLeadingZero);
            }
            html += '</tr></table>' + // Close the hours cells table
                    '</td>' +         // Close the Hour td
                    '<td class="ui-timepicker-minutes">';

            html += this._generateHTMLMinutes(inst);
            
            html += '</td></tr></table>';

            return html;
        },

        /* Special function that update the minutes selection in currently visible timepicker
         * called on hour selection when onMinuteShow is defined  */ 
        _updateMinuteDisplay: function (inst) {
            var newHtml = this._generateHTMLMinutes(inst);
            inst.tpDiv.find('td.ui-timepicker-minutes').html(newHtml);
        },
        
        /* Generate the minutes table */
        _generateHTMLMinutes: function (inst) {

            var m;
            var showMinutesLeadingZero = (this._get(inst, 'showMinutesLeadingZero') == true);
            var onMinuteShow = this._get(inst, 'onMinuteShow');
            // if currently selected minute is not enabled, we have a problem and need to select a new minute.
            if ( (onMinuteShow) ) {

                if (onMinuteShow.apply((inst.input ? inst.input[0] : null), [inst.hours , inst.minutes]) == false) {
                    // loop minutes and select first available
                    for (m = 0; m < 60; m += 5) {
                        if (onMinuteShow.apply((inst.input ? inst.input[0] : null), [inst.hours, m])) {
                            inst.minutes = m;
                            break;
                        }
                    }
                }
            }

            var html = '' + // open minutes td
                       /* Add the minutes */
                       '<div class="ui-timepicker-title ui-widget-header ui-helper-clearfix ui-corner-all">' +
                       this._get(inst, 'minuteText') +
                       '</div>' +
                       '<table class="ui-timepicker">' +
                       '<tr>';
;
            
            for (m = 0; m < 15; m += 5) {
                html += this._generateHTMLMinuteCell(inst, m, (m < 10) && showMinutesLeadingZero ? "0" + m.toString() : m.toString());
            }
            html += '</tr><tr>';
            for (m = 15; m < 30; m += 5) {
                html += this._generateHTMLMinuteCell(inst, m, m.toString());
            }
            html += '</tr><tr>';
            for (m = 30; m < 45; m += 5) {
                html += this._generateHTMLMinuteCell(inst, m, m.toString());
            }
            html += '</tr><tr>';
            for (m = 45; m < 60; m += 5) {
                html += this._generateHTMLMinuteCell(inst, m, m.toString());
            }

            html += '</tr></table>';

            return html;
        },

        /* Generate the content of a "Hour" cell */
        _generateHTMLHourCell: function (inst, hour, showPeriod, showLeadingZero) {

            var displayHour = hour;
            if ((hour > 12) && showPeriod) {
                displayHour = hour - 12;
            }
            if ((displayHour == 0) && showPeriod) {
                displayHour = 12;
            }
            if ((displayHour < 10) && showLeadingZero) {
                displayHour = '0' + displayHour;
            }
            
            var html = "";
            var enabled = true;
            var onHourShow = this._get(inst, 'onHourShow');		//custom callback
            if (onHourShow) {
            	enabled = onHourShow.apply((inst.input ? inst.input[0] : null), [hour]);
            }

            if (enabled) {
            	html = '<td ' +
                   'onclick="TP_jQuery_' + tpuuid + '.timepicker.selectHours(\'#' + inst.id + '\', ' + hour.toString() + ', this ); return false;" ' +
                   'ondblclick="TP_jQuery_' + tpuuid + '.timepicker.selectHours(\'#' + inst.id + '\', ' + hour.toString() + ', this, true ); return false;" ' +
                   '>' +
                   '<a href="#" class="ui-state-default ' +
                   (hour == inst.hours ? 'ui-state-active' : '') +
                   '">' +
                   displayHour.toString() +
                   '</a></td>';
            }
            else {
            	html =
            		'<td>' +
		                '<span class="ui-state-default ui-state-disabled' +
		                (hour == inst.hours ? 'ui-state-active' : '') +
		                '">' +
		                displayHour.toString() +
		                '</span>' +
		            '</td>';
            }
            return html;
        },
        
        /* Generate the content of a "Hour" cell */
        _generateHTMLMinuteCell: function (inst, minute, displayText) {
        	 var html = "";
             var enabled = true;
             var onMinuteShow = this._get(inst, 'onMinuteShow');		//custom callback
             if (onMinuteShow) {
            	 //NEW: 2011-02-03  we should give the hour as a parameter as well!
             	enabled = onMinuteShow.apply((inst.input ? inst.input[0] : null), [inst.hours,minute]);		//trigger callback
             }

             if (enabled) {
	            html = '<td ' +
	                   'onclick="TP_jQuery_' + tpuuid + '.timepicker.selectMinutes(\'#' + inst.id + '\', ' + minute.toString() + ', this ); return false;" ' +
	                   'ondblclick="TP_jQuery_' + tpuuid + '.timepicker.selectMinutes(\'#' + inst.id + '\', ' + minute.toString() + ', this, true ); return false;" ' +
	                   '>' +
	                   '<a href="#" class="ui-state-default ' +
	                   (minute == inst.minutes ? 'ui-state-active' : '') +
	                   '" >' +
	                   displayText +
	                   '</a></td>';
             }
             else {

            	html = '<td>' +
	                 '<span class="ui-state-default ui-state-disabled" >' +
	                 	displayText +
	                 '</span>' +
                 '</td>';
             }
             return html;
        },

        /* Is the first field in a jQuery collection disabled as a timepicker?
        @param  target    element - the target input field or division or span
        @return boolean - true if disabled, false if enabled */
        _isDisabledTimepicker: function (target) {
            if (!target) { return false; }
            for (var i = 0; i < this._disabledInputs.length; i++) {
                if (this._disabledInputs[i] == target) { return true; }
            }
            return false;
        },

        /* Check positioning to remain on screen. */
        _checkOffset: function (inst, offset, isFixed) {
            var tpWidth = inst.tpDiv.outerWidth();
            var tpHeight = inst.tpDiv.outerHeight();
            var inputWidth = inst.input ? inst.input.outerWidth() : 0;
            var inputHeight = inst.input ? inst.input.outerHeight() : 0;
            var viewWidth = document.documentElement.clientWidth + $(document).scrollLeft();
            var viewHeight = document.documentElement.clientHeight + $(document).scrollTop();

            offset.left -= (this._get(inst, 'isRTL') ? (tpWidth - inputWidth) : 0);
            offset.left -= (isFixed && offset.left == inst.input.offset().left) ? $(document).scrollLeft() : 0;
            offset.top -= (isFixed && offset.top == (inst.input.offset().top + inputHeight)) ? $(document).scrollTop() : 0;

            // now check if datepicker is showing outside window viewport - move to a better place if so.
            offset.left -= Math.min(offset.left, (offset.left + tpWidth > viewWidth && viewWidth > tpWidth) ?
			Math.abs(offset.left + tpWidth - viewWidth) : 0);
            offset.top -= Math.min(offset.top, (offset.top + tpHeight > viewHeight && viewHeight > tpHeight) ?
			Math.abs(tpHeight + inputHeight) : 0);

            return offset;
        },

        /* Find an object's position on the screen. */
        _findPos: function (obj) {
            var inst = this._getInst(obj);
            var isRTL = this._get(inst, 'isRTL');
            while (obj && (obj.type == 'hidden' || obj.nodeType != 1)) {
                obj = obj[isRTL ? 'previousSibling' : 'nextSibling'];
            }
            var position = $(obj).offset();
            return [position.left, position.top];
        },

        /* Retrieve the size of left and top borders for an element.
        @param  elem  (jQuery object) the element of interest
        @return  (number[2]) the left and top borders */
        _getBorders: function (elem) {
            var convert = function (value) {
                return { thin: 1, medium: 2, thick: 3}[value] || value;
            };
            return [parseFloat(convert(elem.css('border-left-width'))),
			parseFloat(convert(elem.css('border-top-width')))];
        },


        /* Close time picker if clicked elsewhere. */
        _checkExternalClick: function (event) {
            if (!$.timepicker._curInst) { return; }
            var $target = $(event.target);
            if ($target[0].id != $.timepicker._mainDivId &&
				$target.parents('#' + $.timepicker._mainDivId).length == 0 &&
				!$target.hasClass($.timepicker.markerClassName) &&
				!$target.hasClass($.timepicker._triggerClass) &&
				$.timepicker._timepickerShowing && !($.timepicker._inDialog && $.blockUI))
                $.timepicker._hideTimepicker();
        },

        /* Hide the time picker from view.
        @param  input  element - the input field attached to the time picker */
        _hideTimepicker: function (input) {
            var inst = this._curInst;
            if (!inst || (input && inst != $.data(input, PROP_NAME))) { return; }
            if (this._timepickerShowing) {
                var showAnim = this._get(inst, 'showAnim');
                var duration = this._get(inst, 'duration');
                var postProcess = function () {
                    $.timepicker._tidyDialog(inst);
                    this._curInst = null;
                };
                if ($.effects && $.effects[showAnim]) {
                    inst.tpDiv.hide(showAnim, $.timepicker._get(inst, 'showOptions'), duration, postProcess);
                }
                else {
                    inst.tpDiv[(showAnim == 'slideDown' ? 'slideUp' :
					    (showAnim == 'fadeIn' ? 'fadeOut' : 'hide'))]((showAnim ? duration : null), postProcess);
                }
                if (!showAnim) { postProcess(); }
                var onClose = this._get(inst, 'onClose');
                if (onClose) {
                    onClose.apply(
                        (inst.input ? inst.input[0] : null),
					    [(inst.input ? inst.input.val() : ''), inst]);  // trigger custom callback
                }
                this._timepickerShowing = false;
                this._lastInput = null;
                if (this._inDialog) {
                    this._dialogInput.css({ position: 'absolute', left: '0', top: '-100px' });
                    if ($.blockUI) {
                        $.unblockUI();
                        $('body').append(this.tpDiv);
                    }
                }
                this._inDialog = false;
            }
        },

        /* Tidy up after a dialog display. */
        _tidyDialog: function (inst) {
            inst.tpDiv.removeClass(this._dialogClass).unbind('.ui-timepicker');
        },

        /* Retrieve the instance data for the target control.
        @param  target  element - the target input field or division or span
        @return  object - the associated instance data
        @throws  error if a jQuery problem getting data */
        _getInst: function (target) {
            try {
                return $.data(target, PROP_NAME);
            }
            catch (err) {
                throw 'Missing instance data for this timepicker';
            }
        },

        /* Get a setting value, defaulting if necessary. */
        _get: function (inst, name) {
            return inst.settings[name] !== undefined ?
			inst.settings[name] : this._defaults[name];
        },

        /* Parse existing time and initialise time picker. */
        _setTimeFromField: function (inst) {
            if (inst.input.val() == inst.lastVal) { return; }
            var defaultTime = this._get(inst, 'defaultTime');
            
            
            var timeToParse = this._getCurrentTimeRounded(inst);
            if (defaultTime != '') { timeToParse = defaultTime }
            if ((inst.inline == false) && (inst.input.val() != '')) { timeToParse = inst.input.val() }

            var timeVal = inst.lastVal = timeToParse;

            var time = this.parseTime(inst, timeVal);
            inst.hours = time.hours;
            inst.minutes = time.minutes;

            $.timepicker._updateTimepicker(inst);
        },
        /* Set the dates for a jQuery selection.
	    @param  target   element - the target input field or division or span
	    @param  date     Date - the new date */
	    _setTimeTimepicker: function(target, time) {
		    var inst = this._getInst(target);
		    if (inst) {
			    this._setTime(inst, time);
    			this._updateTimepicker(inst);
	    		this._updateAlternate(inst);
		    }
	    },
        
        /* Set the tm directly. */
        _setTime: function(inst, time, noChange) {
            var clear = !time;
            var origHours = inst.hours;
            var origMinutes = inst.minutes;
            var time = this.parseTime(inst, time);
            inst.hours = time.hours;
            inst.minutes = time.minutes;

            if ((origHours != inst.hours || origMinutes != inst.minuts) && !noChange) {
                inst.input.trigger('change');
            }
            this._updateTimepicker(inst);
            this._updateSelectedValue(inst);
        },

        /* Return the current time, ready to be parsed, rounded to the closest 5 minute */
        _getCurrentTimeRounded: function (inst) {
            var currentTime = new Date();
            var timeSeparator = this._get(inst, 'timeSeparator');
            // setting selected time , least priority first
            var currentMinutes = currentTime.getMinutes()
            // round to closest 5
            currentMinutes = Math.round( currentMinutes / 5 ) * 5;

            return currentTime.getHours().toString() + timeSeparator + currentMinutes.toString();
        },

        /*
        * Pase a time string into hours and minutes
        */
        parseTime: function (inst, timeVal) {
            var retVal = new Object();
            retVal.hours = -1;
            retVal.minutes = -1;

            var timeSeparator = this._get(inst, 'timeSeparator');
            var amPmText = this._get(inst, 'amPmText');
            var p = timeVal.indexOf(timeSeparator);
            if (p == -1) { return retVal; }

            retVal.hours = parseInt(timeVal.substr(0, p), 10);
            retVal.minutes = parseInt(timeVal.substr(p + 1), 10);

            var showPeriod = (this._get(inst, 'showPeriod') == true);
            var timeValUpper = timeVal.toUpperCase();
            if ((retVal.hours < 12) && (showPeriod) && (timeValUpper.indexOf(amPmText[1].toUpperCase()) != -1)) {
                retVal.hours += 12;
            }
            // fix for 12 AM
            if ((retVal.hours == 12) && (showPeriod) && (timeValUpper.indexOf(amPmText[0].toUpperCase()) != -1)) {
                retVal.hours = 0;
            }
            
            return retVal;
        },



        selectHours: function (id, newHours, td, fromDoubleClick) {
            var target = $(id);
            var inst = this._getInst(target[0]);
            $(td).parents('.ui-timepicker-hours:first').find('a').removeClass('ui-state-active');
            //inst.tpDiv.children('.ui-timepicker-hours a').removeClass('ui-state-active');
            $(td).children('a').addClass('ui-state-active');

            inst.hours = newHours;
            this._updateSelectedValue(inst);

            inst._hoursClicked = true;
            if ((inst._minutesClicked) || (fromDoubleClick)) {
                $.timepicker._hideTimepicker();
                return;
            }
            // added for onMinuteShow callback
            var onMinuteShow = this._get(inst, 'onMinuteShow');
            if (onMinuteShow) { this._updateMinuteDisplay(inst); }
        },

        selectMinutes: function (id, newMinutes, td, fromDoubleClick) {
            var target = $(id);
            var inst = this._getInst(target[0]);
            $(td).parents('.ui-timepicker-minutes:first').find('a').removeClass('ui-state-active');
            $(td).children('a').addClass('ui-state-active');

            inst.minutes = newMinutes;
            this._updateSelectedValue(inst);

            inst._minutesClicked = true;
            if ((inst._hoursClicked) || (fromDoubleClick)) { $.timepicker._hideTimepicker(); }
        },

        _updateSelectedValue: function (inst) {
            if ((inst.hours < 0) || (inst.hours > 23)) { inst.hours = 12; }
            if ((inst.minutes < 0) || (inst.minutes > 59)) { inst.minutes = 0; }

            var period = "";
            var showPeriod = (this._get(inst, 'showPeriod') == true);
            var showLeadingZero = (this._get(inst, 'showLeadingZero') == true);
            var amPmText = this._get(inst, 'amPmText');
            var selectedHours = inst.hours ? inst.hours : 0;
            var selectedMinutes = inst.minutes ? inst.minutes : 0;
            
            var displayHours = selectedHours;
            if ( ! displayHours) {
                displayHoyrs = 0;
            }

            
            if (showPeriod) {
                if (inst.hours == 0) {
                    displayHours = 12;
                }
                if (inst.hours < 12) {
                    period = amPmText[0];
                }
                else {
                    period = amPmText[1];
                    if (displayHours > 12) {
                        displayHours -= 12;
                    }
                }
            }

            var h = displayHours.toString();
            if (showLeadingZero && (displayHours < 10)) { h = '0' + h; }

            
            var m = selectedMinutes.toString();
            if (selectedMinutes < 10) { m = '0' + m; }

            var newTime = h + this._get(inst, 'timeSeparator') + m;
            if (period.length > 0) { newTime += " " + period; }

            if (inst.input) {
                inst.input.val(newTime);
                inst.input.trigger('change');
            }

            var onSelect = this._get(inst, 'onSelect');
            if (onSelect) { onSelect.apply((inst.input ? inst.input[0] : null), [newTime, inst]); } // trigger custom callback

            this._updateAlternate(inst, newTime);

            return newTime;
        },
        
        /* Update any alternate field to synchronise with the main field. */
        _updateAlternate: function(inst, newTime) {
            var altField = this._get(inst, 'altField');
            if (altField) { // update alternate field too
                $(altField).each(function() { $(this).val(newTime); });
            }
        }
    });



    /* Invoke the timepicker functionality.
    @param  options  string - a command, optionally followed by additional parameters or
    Object - settings for attaching new datepicker functionality
    @return  jQuery object */
    $.fn.timepicker = function (options) {

        /* Initialise the date picker. */
        if (!$.timepicker.initialized) {
            $(document).mousedown($.timepicker._checkExternalClick).
			find('body').append($.timepicker.tpDiv);
            $.timepicker.initialized = true;
        }

        var otherArgs = Array.prototype.slice.call(arguments, 1);
        if (typeof options == 'string' && (options == 'isDisabled' || options == 'getTime' || options == 'widget'))
            return $.timepicker['_' + options + 'Datepicker'].
			apply($.timepicker, [this[0]].concat(otherArgs));
        if (options == 'option' && arguments.length == 2 && typeof arguments[1] == 'string')
            return $.timepicker['_' + options + 'Datepicker'].
			apply($.timepicker, [this[0]].concat(otherArgs));
        return this.each(function () {
            typeof options == 'string' ?
			$.timepicker['_' + options + 'Timepicker'].
				apply($.timepicker, [this].concat(otherArgs)) :
			$.timepicker._attachTimepicker(this, options);
        });
    };

    /* jQuery extend now ignores nulls! */
    function extendRemove(target, props) {
        $.extend(target, props);
        for (var name in props)
            if (props[name] == null || props[name] == undefined)
                target[name] = props[name];
        return target;
    };

    $.timepicker = new Timepicker(); // singleton instance
    $.timepicker.initialized = false;
    $.timepicker.uuid = new Date().getTime();
    $.timepicker.version = "1.8.6";

    // Workaround for #4055
    // Add another global to avoid noConflict issues with inline event handlers
    window['TP_jQuery_' + tpuuid] = $;

})(jQuery);

/*
                                                  ____
       ___                                      .-~. /_"-._
      `-._~-.                                  / /_ "~o\  :Y
          \  \                                / : \~x.  ` ')
           ]  Y                              /  |  Y< ~-.__j
          /   !                        _.--~T : l  l<  /.-~
         /   /                 ____.--~ .   ` l /~\ \<|Y
        /   /             .-~~"        /| .    ',-~\ \L|
       /   /             /     .^   \ Y~Y \.^>/l_   "--'
      /   Y           .-"(  .  l__  j_j l_/ /~_.-~    .
     Y    l          /    \  )    ~~~." / `/"~ / \.__/l_
     |     \     _.-"      ~-{__     l  :  l._Z~-.___.--~
     |      ~---~           /   ~~"---\_  ' __[>
     l  .                _.^   ___     _>-y~
      \  \     .      .-~   .-~   ~>--"  /
       \  ~---"            /     ./  _.-'
        "-.,_____.,_  _.--~\     _.-~
                    ~~     (   _}       -Row
                           `. ~(
                             )  \
                            /,`--'~\--'~\
                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             ->T-Rex<-
*/