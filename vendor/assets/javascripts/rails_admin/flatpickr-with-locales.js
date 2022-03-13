/* flatpickr v4.6.11, @license MIT */
(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
    (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.flatpickr = factory());
}(this, (function () { 'use strict';

    /*! *****************************************************************************
    Copyright (c) Microsoft Corporation.

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
    ***************************************************************************** */

    var __assign = function() {
        __assign = Object.assign || function __assign(t) {
            for (var s, i = 1, n = arguments.length; i < n; i++) {
                s = arguments[i];
                for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
            }
            return t;
        };
        return __assign.apply(this, arguments);
    };

    function __spreadArrays() {
        for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
        for (var r = Array(s), k = 0, i = 0; i < il; i++)
            for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
                r[k] = a[j];
        return r;
    }

    var HOOKS = [
        "onChange",
        "onClose",
        "onDayCreate",
        "onDestroy",
        "onKeyDown",
        "onMonthChange",
        "onOpen",
        "onParseConfig",
        "onReady",
        "onValueUpdate",
        "onYearChange",
        "onPreCalendarPosition",
    ];
    var defaults = {
        _disable: [],
        allowInput: false,
        allowInvalidPreload: false,
        altFormat: "F j, Y",
        altInput: false,
        altInputClass: "form-control input",
        animate: typeof window === "object" &&
            window.navigator.userAgent.indexOf("MSIE") === -1,
        ariaDateFormat: "F j, Y",
        autoFillDefaultTime: true,
        clickOpens: true,
        closeOnSelect: true,
        conjunction: ", ",
        dateFormat: "Y-m-d",
        defaultHour: 12,
        defaultMinute: 0,
        defaultSeconds: 0,
        disable: [],
        disableMobile: false,
        enableSeconds: false,
        enableTime: false,
        errorHandler: function (err) {
            return typeof console !== "undefined" && console.warn(err);
        },
        getWeek: function (givenDate) {
            var date = new Date(givenDate.getTime());
            date.setHours(0, 0, 0, 0);
            // Thursday in current week decides the year.
            date.setDate(date.getDate() + 3 - ((date.getDay() + 6) % 7));
            // January 4 is always in week 1.
            var week1 = new Date(date.getFullYear(), 0, 4);
            // Adjust to Thursday in week 1 and count number of weeks from date to week1.
            return (1 +
                Math.round(((date.getTime() - week1.getTime()) / 86400000 -
                    3 +
                    ((week1.getDay() + 6) % 7)) /
                    7));
        },
        hourIncrement: 1,
        ignoredFocusElements: [],
        inline: false,
        locale: "default",
        minuteIncrement: 5,
        mode: "single",
        monthSelectorType: "dropdown",
        nextArrow: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 17 17'><g></g><path d='M13.207 8.472l-7.854 7.854-0.707-0.707 7.146-7.146-7.146-7.148 0.707-0.707 7.854 7.854z' /></svg>",
        noCalendar: false,
        now: new Date(),
        onChange: [],
        onClose: [],
        onDayCreate: [],
        onDestroy: [],
        onKeyDown: [],
        onMonthChange: [],
        onOpen: [],
        onParseConfig: [],
        onReady: [],
        onValueUpdate: [],
        onYearChange: [],
        onPreCalendarPosition: [],
        plugins: [],
        position: "auto",
        positionElement: undefined,
        prevArrow: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 17 17'><g></g><path d='M5.207 8.471l7.146 7.147-0.707 0.707-7.853-7.854 7.854-7.853 0.707 0.707-7.147 7.146z' /></svg>",
        shorthandCurrentMonth: false,
        showMonths: 1,
        static: false,
        time_24hr: false,
        weekNumbers: false,
        wrap: false,
    };

    var english = {
        weekdays: {
            shorthand: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            longhand: [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec",
            ],
            longhand: [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
            ],
        },
        daysInMonth: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        firstDayOfWeek: 0,
        ordinal: function (nth) {
            var s = nth % 100;
            if (s > 3 && s < 21)
                return "th";
            switch (s % 10) {
                case 1:
                    return "st";
                case 2:
                    return "nd";
                case 3:
                    return "rd";
                default:
                    return "th";
            }
        },
        rangeSeparator: " to ",
        weekAbbreviation: "Wk",
        scrollTitle: "Scroll to increment",
        toggleTitle: "Click to toggle",
        amPM: ["AM", "PM"],
        yearAriaLabel: "Year",
        monthAriaLabel: "Month",
        hourAriaLabel: "Hour",
        minuteAriaLabel: "Minute",
        time_24hr: false,
    };

    var pad = function (number, length) {
        if (length === void 0) { length = 2; }
        return ("000" + number).slice(length * -1);
    };
    var int = function (bool) { return (bool === true ? 1 : 0); };
    /* istanbul ignore next */
    function debounce(fn, wait) {
        var t;
        return function () {
            var _this = this;
            var args = arguments;
            clearTimeout(t);
            t = setTimeout(function () { return fn.apply(_this, args); }, wait);
        };
    }
    var arrayify = function (obj) {
        return obj instanceof Array ? obj : [obj];
    };

    function toggleClass(elem, className, bool) {
        if (bool === true)
            return elem.classList.add(className);
        elem.classList.remove(className);
    }
    function createElement(tag, className, content) {
        var e = window.document.createElement(tag);
        className = className || "";
        content = content || "";
        e.className = className;
        if (content !== undefined)
            e.textContent = content;
        return e;
    }
    function clearNode(node) {
        while (node.firstChild)
            node.removeChild(node.firstChild);
    }
    function findParent(node, condition) {
        if (condition(node))
            return node;
        else if (node.parentNode)
            return findParent(node.parentNode, condition);
        return undefined; // nothing found
    }
    function createNumberInput(inputClassName, opts) {
        var wrapper = createElement("div", "numInputWrapper"), numInput = createElement("input", "numInput " + inputClassName), arrowUp = createElement("span", "arrowUp"), arrowDown = createElement("span", "arrowDown");
        if (navigator.userAgent.indexOf("MSIE 9.0") === -1) {
            numInput.type = "number";
        }
        else {
            numInput.type = "text";
            numInput.pattern = "\\d*";
        }
        if (opts !== undefined)
            for (var key in opts)
                numInput.setAttribute(key, opts[key]);
        wrapper.appendChild(numInput);
        wrapper.appendChild(arrowUp);
        wrapper.appendChild(arrowDown);
        return wrapper;
    }
    function getEventTarget(event) {
        try {
            if (typeof event.composedPath === "function") {
                var path = event.composedPath();
                return path[0];
            }
            return event.target;
        }
        catch (error) {
            return event.target;
        }
    }

    var doNothing = function () { return undefined; };
    var monthToStr = function (monthNumber, shorthand, locale) { return locale.months[shorthand ? "shorthand" : "longhand"][monthNumber]; };
    var revFormat = {
        D: doNothing,
        F: function (dateObj, monthName, locale) {
            dateObj.setMonth(locale.months.longhand.indexOf(monthName));
        },
        G: function (dateObj, hour) {
            dateObj.setHours((dateObj.getHours() >= 12 ? 12 : 0) + parseFloat(hour));
        },
        H: function (dateObj, hour) {
            dateObj.setHours(parseFloat(hour));
        },
        J: function (dateObj, day) {
            dateObj.setDate(parseFloat(day));
        },
        K: function (dateObj, amPM, locale) {
            dateObj.setHours((dateObj.getHours() % 12) +
                12 * int(new RegExp(locale.amPM[1], "i").test(amPM)));
        },
        M: function (dateObj, shortMonth, locale) {
            dateObj.setMonth(locale.months.shorthand.indexOf(shortMonth));
        },
        S: function (dateObj, seconds) {
            dateObj.setSeconds(parseFloat(seconds));
        },
        U: function (_, unixSeconds) { return new Date(parseFloat(unixSeconds) * 1000); },
        W: function (dateObj, weekNum, locale) {
            var weekNumber = parseInt(weekNum);
            var date = new Date(dateObj.getFullYear(), 0, 2 + (weekNumber - 1) * 7, 0, 0, 0, 0);
            date.setDate(date.getDate() - date.getDay() + locale.firstDayOfWeek);
            return date;
        },
        Y: function (dateObj, year) {
            dateObj.setFullYear(parseFloat(year));
        },
        Z: function (_, ISODate) { return new Date(ISODate); },
        d: function (dateObj, day) {
            dateObj.setDate(parseFloat(day));
        },
        h: function (dateObj, hour) {
            dateObj.setHours((dateObj.getHours() >= 12 ? 12 : 0) + parseFloat(hour));
        },
        i: function (dateObj, minutes) {
            dateObj.setMinutes(parseFloat(minutes));
        },
        j: function (dateObj, day) {
            dateObj.setDate(parseFloat(day));
        },
        l: doNothing,
        m: function (dateObj, month) {
            dateObj.setMonth(parseFloat(month) - 1);
        },
        n: function (dateObj, month) {
            dateObj.setMonth(parseFloat(month) - 1);
        },
        s: function (dateObj, seconds) {
            dateObj.setSeconds(parseFloat(seconds));
        },
        u: function (_, unixMillSeconds) {
            return new Date(parseFloat(unixMillSeconds));
        },
        w: doNothing,
        y: function (dateObj, year) {
            dateObj.setFullYear(2000 + parseFloat(year));
        },
    };
    var tokenRegex = {
        D: "",
        F: "",
        G: "(\\d\\d|\\d)",
        H: "(\\d\\d|\\d)",
        J: "(\\d\\d|\\d)\\w+",
        K: "",
        M: "",
        S: "(\\d\\d|\\d)",
        U: "(.+)",
        W: "(\\d\\d|\\d)",
        Y: "(\\d{4})",
        Z: "(.+)",
        d: "(\\d\\d|\\d)",
        h: "(\\d\\d|\\d)",
        i: "(\\d\\d|\\d)",
        j: "(\\d\\d|\\d)",
        l: "",
        m: "(\\d\\d|\\d)",
        n: "(\\d\\d|\\d)",
        s: "(\\d\\d|\\d)",
        u: "(.+)",
        w: "(\\d\\d|\\d)",
        y: "(\\d{2})",
    };
    var formats = {
        // get the date in UTC
        Z: function (date) { return date.toISOString(); },
        // weekday name, short, e.g. Thu
        D: function (date, locale, options) {
            return locale.weekdays.shorthand[formats.w(date, locale, options)];
        },
        // full month name e.g. January
        F: function (date, locale, options) {
            return monthToStr(formats.n(date, locale, options) - 1, false, locale);
        },
        // padded hour 1-12
        G: function (date, locale, options) {
            return pad(formats.h(date, locale, options));
        },
        // hours with leading zero e.g. 03
        H: function (date) { return pad(date.getHours()); },
        // day (1-30) with ordinal suffix e.g. 1st, 2nd
        J: function (date, locale) {
            return locale.ordinal !== undefined
                ? date.getDate() + locale.ordinal(date.getDate())
                : date.getDate();
        },
        // AM/PM
        K: function (date, locale) { return locale.amPM[int(date.getHours() > 11)]; },
        // shorthand month e.g. Jan, Sep, Oct, etc
        M: function (date, locale) {
            return monthToStr(date.getMonth(), true, locale);
        },
        // seconds 00-59
        S: function (date) { return pad(date.getSeconds()); },
        // unix timestamp
        U: function (date) { return date.getTime() / 1000; },
        W: function (date, _, options) {
            return options.getWeek(date);
        },
        // full year e.g. 2016, padded (0001-9999)
        Y: function (date) { return pad(date.getFullYear(), 4); },
        // day in month, padded (01-30)
        d: function (date) { return pad(date.getDate()); },
        // hour from 1-12 (am/pm)
        h: function (date) { return (date.getHours() % 12 ? date.getHours() % 12 : 12); },
        // minutes, padded with leading zero e.g. 09
        i: function (date) { return pad(date.getMinutes()); },
        // day in month (1-30)
        j: function (date) { return date.getDate(); },
        // weekday name, full, e.g. Thursday
        l: function (date, locale) {
            return locale.weekdays.longhand[date.getDay()];
        },
        // padded month number (01-12)
        m: function (date) { return pad(date.getMonth() + 1); },
        // the month number (1-12)
        n: function (date) { return date.getMonth() + 1; },
        // seconds 0-59
        s: function (date) { return date.getSeconds(); },
        // Unix Milliseconds
        u: function (date) { return date.getTime(); },
        // number of the day of the week
        w: function (date) { return date.getDay(); },
        // last two digits of year e.g. 16 for 2016
        y: function (date) { return String(date.getFullYear()).substring(2); },
    };

    var createDateFormatter = function (_a) {
        var _b = _a.config, config = _b === void 0 ? defaults : _b, _c = _a.l10n, l10n = _c === void 0 ? english : _c, _d = _a.isMobile, isMobile = _d === void 0 ? false : _d;
        return function (dateObj, frmt, overrideLocale) {
            var locale = overrideLocale || l10n;
            if (config.formatDate !== undefined && !isMobile) {
                return config.formatDate(dateObj, frmt, locale);
            }
            return frmt
                .split("")
                .map(function (c, i, arr) {
                return formats[c] && arr[i - 1] !== "\\"
                    ? formats[c](dateObj, locale, config)
                    : c !== "\\"
                        ? c
                        : "";
            })
                .join("");
        };
    };
    var createDateParser = function (_a) {
        var _b = _a.config, config = _b === void 0 ? defaults : _b, _c = _a.l10n, l10n = _c === void 0 ? english : _c;
        return function (date, givenFormat, timeless, customLocale) {
            if (date !== 0 && !date)
                return undefined;
            var locale = customLocale || l10n;
            var parsedDate;
            var dateOrig = date;
            if (date instanceof Date)
                parsedDate = new Date(date.getTime());
            else if (typeof date !== "string" &&
                date.toFixed !== undefined // timestamp
            )
                // create a copy
                parsedDate = new Date(date);
            else if (typeof date === "string") {
                // date string
                var format = givenFormat || (config || defaults).dateFormat;
                var datestr = String(date).trim();
                if (datestr === "today") {
                    parsedDate = new Date();
                    timeless = true;
                }
                else if (config && config.parseDate) {
                    parsedDate = config.parseDate(date, format);
                }
                else if (/Z$/.test(datestr) ||
                    /GMT$/.test(datestr) // datestrings w/ timezone
                ) {
                    parsedDate = new Date(date);
                }
                else {
                    var matched = void 0, ops = [];
                    for (var i = 0, matchIndex = 0, regexStr = ""; i < format.length; i++) {
                        var token_1 = format[i];
                        var isBackSlash = token_1 === "\\";
                        var escaped = format[i - 1] === "\\" || isBackSlash;
                        if (tokenRegex[token_1] && !escaped) {
                            regexStr += tokenRegex[token_1];
                            var match = new RegExp(regexStr).exec(date);
                            if (match && (matched = true)) {
                                ops[token_1 !== "Y" ? "push" : "unshift"]({
                                    fn: revFormat[token_1],
                                    val: match[++matchIndex],
                                });
                            }
                        }
                        else if (!isBackSlash)
                            regexStr += "."; // don't really care
                    }
                    parsedDate =
                        !config || !config.noCalendar
                            ? new Date(new Date().getFullYear(), 0, 1, 0, 0, 0, 0)
                            : new Date(new Date().setHours(0, 0, 0, 0));
                    ops.forEach(function (_a) {
                        var fn = _a.fn, val = _a.val;
                        return (parsedDate = fn(parsedDate, val, locale) || parsedDate);
                    });
                    parsedDate = matched ? parsedDate : undefined;
                }
            }
            /* istanbul ignore next */
            if (!(parsedDate instanceof Date && !isNaN(parsedDate.getTime()))) {
                config.errorHandler(new Error("Invalid date provided: " + dateOrig));
                return undefined;
            }
            if (timeless === true)
                parsedDate.setHours(0, 0, 0, 0);
            return parsedDate;
        };
    };
    /**
     * Compute the difference in dates, measured in ms
     */
    function compareDates(date1, date2, timeless) {
        if (timeless === void 0) { timeless = true; }
        if (timeless !== false) {
            return (new Date(date1.getTime()).setHours(0, 0, 0, 0) -
                new Date(date2.getTime()).setHours(0, 0, 0, 0));
        }
        return date1.getTime() - date2.getTime();
    }
    var isBetween = function (ts, ts1, ts2) {
        return ts > Math.min(ts1, ts2) && ts < Math.max(ts1, ts2);
    };
    var calculateSecondsSinceMidnight = function (hours, minutes, seconds) {
        return hours * 3600 + minutes * 60 + seconds;
    };
    var parseSeconds = function (secondsSinceMidnight) {
        var hours = Math.floor(secondsSinceMidnight / 3600), minutes = (secondsSinceMidnight - hours * 3600) / 60;
        return [hours, minutes, secondsSinceMidnight - hours * 3600 - minutes * 60];
    };
    var duration = {
        DAY: 86400000,
    };
    function getDefaultHours(config) {
        var hours = config.defaultHour;
        var minutes = config.defaultMinute;
        var seconds = config.defaultSeconds;
        if (config.minDate !== undefined) {
            var minHour = config.minDate.getHours();
            var minMinutes = config.minDate.getMinutes();
            var minSeconds = config.minDate.getSeconds();
            if (hours < minHour) {
                hours = minHour;
            }
            if (hours === minHour && minutes < minMinutes) {
                minutes = minMinutes;
            }
            if (hours === minHour && minutes === minMinutes && seconds < minSeconds)
                seconds = config.minDate.getSeconds();
        }
        if (config.maxDate !== undefined) {
            var maxHr = config.maxDate.getHours();
            var maxMinutes = config.maxDate.getMinutes();
            hours = Math.min(hours, maxHr);
            if (hours === maxHr)
                minutes = Math.min(maxMinutes, minutes);
            if (hours === maxHr && minutes === maxMinutes)
                seconds = config.maxDate.getSeconds();
        }
        return { hours: hours, minutes: minutes, seconds: seconds };
    }

    if (typeof Object.assign !== "function") {
        Object.assign = function (target) {
            var args = [];
            for (var _i = 1; _i < arguments.length; _i++) {
                args[_i - 1] = arguments[_i];
            }
            if (!target) {
                throw TypeError("Cannot convert undefined or null to object");
            }
            var _loop_1 = function (source) {
                if (source) {
                    Object.keys(source).forEach(function (key) { return (target[key] = source[key]); });
                }
            };
            for (var _a = 0, args_1 = args; _a < args_1.length; _a++) {
                var source = args_1[_a];
                _loop_1(source);
            }
            return target;
        };
    }

    var DEBOUNCED_CHANGE_MS = 300;
    function FlatpickrInstance(element, instanceConfig) {
        var self = {
            config: __assign(__assign({}, defaults), flatpickr.defaultConfig),
            l10n: english,
        };
        self.parseDate = createDateParser({ config: self.config, l10n: self.l10n });
        self._handlers = [];
        self.pluginElements = [];
        self.loadedPlugins = [];
        self._bind = bind;
        self._setHoursFromDate = setHoursFromDate;
        self._positionCalendar = positionCalendar;
        self.changeMonth = changeMonth;
        self.changeYear = changeYear;
        self.clear = clear;
        self.close = close;
        self.onMouseOver = onMouseOver;
        self._createElement = createElement;
        self.createDay = createDay;
        self.destroy = destroy;
        self.isEnabled = isEnabled;
        self.jumpToDate = jumpToDate;
        self.updateValue = updateValue;
        self.open = open;
        self.redraw = redraw;
        self.set = set;
        self.setDate = setDate;
        self.toggle = toggle;
        function setupHelperFunctions() {
            self.utils = {
                getDaysInMonth: function (month, yr) {
                    if (month === void 0) { month = self.currentMonth; }
                    if (yr === void 0) { yr = self.currentYear; }
                    if (month === 1 && ((yr % 4 === 0 && yr % 100 !== 0) || yr % 400 === 0))
                        return 29;
                    return self.l10n.daysInMonth[month];
                },
            };
        }
        function init() {
            self.element = self.input = element;
            self.isOpen = false;
            parseConfig();
            setupLocale();
            setupInputs();
            setupDates();
            setupHelperFunctions();
            if (!self.isMobile)
                build();
            bindEvents();
            if (self.selectedDates.length || self.config.noCalendar) {
                if (self.config.enableTime) {
                    setHoursFromDate(self.config.noCalendar ? self.latestSelectedDateObj : undefined);
                }
                updateValue(false);
            }
            setCalendarWidth();
            var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
            /* TODO: investigate this further
        
              Currently, there is weird positioning behavior in safari causing pages
              to scroll up. https://github.com/chmln/flatpickr/issues/563
        
              However, most browsers are not Safari and positioning is expensive when used
              in scale. https://github.com/chmln/flatpickr/issues/1096
            */
            if (!self.isMobile && isSafari) {
                positionCalendar();
            }
            triggerEvent("onReady");
        }
        function getClosestActiveElement() {
            var _a;
            return ((_a = self.calendarContainer) === null || _a === void 0 ? void 0 : _a.getRootNode()).activeElement || document.activeElement;
        }
        function bindToInstance(fn) {
            return fn.bind(self);
        }
        function setCalendarWidth() {
            var config = self.config;
            if (config.weekNumbers === false && config.showMonths === 1) {
                return;
            }
            else if (config.noCalendar !== true) {
                window.requestAnimationFrame(function () {
                    if (self.calendarContainer !== undefined) {
                        self.calendarContainer.style.visibility = "hidden";
                        self.calendarContainer.style.display = "block";
                    }
                    if (self.daysContainer !== undefined) {
                        var daysWidth = (self.days.offsetWidth + 1) * config.showMonths;
                        self.daysContainer.style.width = daysWidth + "px";
                        self.calendarContainer.style.width =
                            daysWidth +
                                (self.weekWrapper !== undefined
                                    ? self.weekWrapper.offsetWidth
                                    : 0) +
                                "px";
                        self.calendarContainer.style.removeProperty("visibility");
                        self.calendarContainer.style.removeProperty("display");
                    }
                });
            }
        }
        /**
         * The handler for all events targeting the time inputs
         */
        function updateTime(e) {
            if (self.selectedDates.length === 0) {
                var defaultDate = self.config.minDate === undefined ||
                    compareDates(new Date(), self.config.minDate) >= 0
                    ? new Date()
                    : new Date(self.config.minDate.getTime());
                var defaults = getDefaultHours(self.config);
                defaultDate.setHours(defaults.hours, defaults.minutes, defaults.seconds, defaultDate.getMilliseconds());
                self.selectedDates = [defaultDate];
                self.latestSelectedDateObj = defaultDate;
            }
            if (e !== undefined && e.type !== "blur") {
                timeWrapper(e);
            }
            var prevValue = self._input.value;
            setHoursFromInputs();
            updateValue();
            if (self._input.value !== prevValue) {
                self._debouncedChange();
            }
        }
        function ampm2military(hour, amPM) {
            return (hour % 12) + 12 * int(amPM === self.l10n.amPM[1]);
        }
        function military2ampm(hour) {
            switch (hour % 24) {
                case 0:
                case 12:
                    return 12;
                default:
                    return hour % 12;
            }
        }
        /**
         * Syncs the selected date object time with user's time input
         */
        function setHoursFromInputs() {
            if (self.hourElement === undefined || self.minuteElement === undefined)
                return;
            var hours = (parseInt(self.hourElement.value.slice(-2), 10) || 0) % 24, minutes = (parseInt(self.minuteElement.value, 10) || 0) % 60, seconds = self.secondElement !== undefined
                ? (parseInt(self.secondElement.value, 10) || 0) % 60
                : 0;
            if (self.amPM !== undefined) {
                hours = ampm2military(hours, self.amPM.textContent);
            }
            var limitMinHours = self.config.minTime !== undefined ||
                (self.config.minDate &&
                    self.minDateHasTime &&
                    self.latestSelectedDateObj &&
                    compareDates(self.latestSelectedDateObj, self.config.minDate, true) ===
                        0);
            var limitMaxHours = self.config.maxTime !== undefined ||
                (self.config.maxDate &&
                    self.maxDateHasTime &&
                    self.latestSelectedDateObj &&
                    compareDates(self.latestSelectedDateObj, self.config.maxDate, true) ===
                        0);
            if (self.config.maxTime !== undefined &&
                self.config.minTime !== undefined &&
                self.config.minTime > self.config.maxTime) {
                var minBound = calculateSecondsSinceMidnight(self.config.minTime.getHours(), self.config.minTime.getMinutes(), self.config.minTime.getSeconds());
                var maxBound = calculateSecondsSinceMidnight(self.config.maxTime.getHours(), self.config.maxTime.getMinutes(), self.config.maxTime.getSeconds());
                var currentTime = calculateSecondsSinceMidnight(hours, minutes, seconds);
                if (currentTime > maxBound && currentTime < minBound) {
                    var result = parseSeconds(minBound);
                    hours = result[0];
                    minutes = result[1];
                    seconds = result[2];
                }
            }
            else {
                if (limitMaxHours) {
                    var maxTime = self.config.maxTime !== undefined
                        ? self.config.maxTime
                        : self.config.maxDate;
                    hours = Math.min(hours, maxTime.getHours());
                    if (hours === maxTime.getHours())
                        minutes = Math.min(minutes, maxTime.getMinutes());
                    if (minutes === maxTime.getMinutes())
                        seconds = Math.min(seconds, maxTime.getSeconds());
                }
                if (limitMinHours) {
                    var minTime = self.config.minTime !== undefined
                        ? self.config.minTime
                        : self.config.minDate;
                    hours = Math.max(hours, minTime.getHours());
                    if (hours === minTime.getHours() && minutes < minTime.getMinutes())
                        minutes = minTime.getMinutes();
                    if (minutes === minTime.getMinutes())
                        seconds = Math.max(seconds, minTime.getSeconds());
                }
            }
            setHours(hours, minutes, seconds);
        }
        /**
         * Syncs time input values with a date
         */
        function setHoursFromDate(dateObj) {
            var date = dateObj || self.latestSelectedDateObj;
            if (date && date instanceof Date) {
                setHours(date.getHours(), date.getMinutes(), date.getSeconds());
            }
        }
        /**
         * Sets the hours, minutes, and optionally seconds
         * of the latest selected date object and the
         * corresponding time inputs
         * @param {Number} hours the hour. whether its military
         *                 or am-pm gets inferred from config
         * @param {Number} minutes the minutes
         * @param {Number} seconds the seconds (optional)
         */
        function setHours(hours, minutes, seconds) {
            if (self.latestSelectedDateObj !== undefined) {
                self.latestSelectedDateObj.setHours(hours % 24, minutes, seconds || 0, 0);
            }
            if (!self.hourElement || !self.minuteElement || self.isMobile)
                return;
            self.hourElement.value = pad(!self.config.time_24hr
                ? ((12 + hours) % 12) + 12 * int(hours % 12 === 0)
                : hours);
            self.minuteElement.value = pad(minutes);
            if (self.amPM !== undefined)
                self.amPM.textContent = self.l10n.amPM[int(hours >= 12)];
            if (self.secondElement !== undefined)
                self.secondElement.value = pad(seconds);
        }
        /**
         * Handles the year input and incrementing events
         * @param {Event} event the keyup or increment event
         */
        function onYearInput(event) {
            var eventTarget = getEventTarget(event);
            var year = parseInt(eventTarget.value) + (event.delta || 0);
            if (year / 1000 > 1 ||
                (event.key === "Enter" && !/[^\d]/.test(year.toString()))) {
                changeYear(year);
            }
        }
        /**
         * Essentially addEventListener + tracking
         * @param {Element} element the element to addEventListener to
         * @param {String} event the event name
         * @param {Function} handler the event handler
         */
        function bind(element, event, handler, options) {
            if (event instanceof Array)
                return event.forEach(function (ev) { return bind(element, ev, handler, options); });
            if (element instanceof Array)
                return element.forEach(function (el) { return bind(el, event, handler, options); });
            element.addEventListener(event, handler, options);
            self._handlers.push({
                remove: function () { return element.removeEventListener(event, handler, options); },
            });
        }
        function triggerChange() {
            triggerEvent("onChange");
        }
        /**
         * Adds all the necessary event listeners
         */
        function bindEvents() {
            if (self.config.wrap) {
                ["open", "close", "toggle", "clear"].forEach(function (evt) {
                    Array.prototype.forEach.call(self.element.querySelectorAll("[data-" + evt + "]"), function (el) {
                        return bind(el, "click", self[evt]);
                    });
                });
            }
            if (self.isMobile) {
                setupMobile();
                return;
            }
            var debouncedResize = debounce(onResize, 50);
            self._debouncedChange = debounce(triggerChange, DEBOUNCED_CHANGE_MS);
            if (self.daysContainer && !/iPhone|iPad|iPod/i.test(navigator.userAgent))
                bind(self.daysContainer, "mouseover", function (e) {
                    if (self.config.mode === "range")
                        onMouseOver(getEventTarget(e));
                });
            bind(self._input, "keydown", onKeyDown);
            if (self.calendarContainer !== undefined) {
                bind(self.calendarContainer, "keydown", onKeyDown);
            }
            if (!self.config.inline && !self.config.static)
                bind(window, "resize", debouncedResize);
            if (window.ontouchstart !== undefined)
                bind(window.document, "touchstart", documentClick);
            else
                bind(window.document, "mousedown", documentClick);
            bind(window.document, "focus", documentClick, { capture: true });
            if (self.config.clickOpens === true) {
                bind(self._input, "focus", self.open);
                bind(self._input, "click", self.open);
            }
            if (self.daysContainer !== undefined) {
                bind(self.monthNav, "click", onMonthNavClick);
                bind(self.monthNav, ["keyup", "increment"], onYearInput);
                bind(self.daysContainer, "click", selectDate);
            }
            if (self.timeContainer !== undefined &&
                self.minuteElement !== undefined &&
                self.hourElement !== undefined) {
                var selText = function (e) {
                    return getEventTarget(e).select();
                };
                bind(self.timeContainer, ["increment"], updateTime);
                bind(self.timeContainer, "blur", updateTime, { capture: true });
                bind(self.timeContainer, "click", timeIncrement);
                bind([self.hourElement, self.minuteElement], ["focus", "click"], selText);
                if (self.secondElement !== undefined)
                    bind(self.secondElement, "focus", function () { return self.secondElement && self.secondElement.select(); });
                if (self.amPM !== undefined) {
                    bind(self.amPM, "click", function (e) {
                        updateTime(e);
                    });
                }
            }
            if (self.config.allowInput) {
                bind(self._input, "blur", onBlur);
            }
        }
        /**
         * Set the calendar view to a particular date.
         * @param {Date} jumpDate the date to set the view to
         * @param {boolean} triggerChange if change events should be triggered
         */
        function jumpToDate(jumpDate, triggerChange) {
            var jumpTo = jumpDate !== undefined
                ? self.parseDate(jumpDate)
                : self.latestSelectedDateObj ||
                    (self.config.minDate && self.config.minDate > self.now
                        ? self.config.minDate
                        : self.config.maxDate && self.config.maxDate < self.now
                            ? self.config.maxDate
                            : self.now);
            var oldYear = self.currentYear;
            var oldMonth = self.currentMonth;
            try {
                if (jumpTo !== undefined) {
                    self.currentYear = jumpTo.getFullYear();
                    self.currentMonth = jumpTo.getMonth();
                }
            }
            catch (e) {
                /* istanbul ignore next */
                e.message = "Invalid date supplied: " + jumpTo;
                self.config.errorHandler(e);
            }
            if (triggerChange && self.currentYear !== oldYear) {
                triggerEvent("onYearChange");
                buildMonthSwitch();
            }
            if (triggerChange &&
                (self.currentYear !== oldYear || self.currentMonth !== oldMonth)) {
                triggerEvent("onMonthChange");
            }
            self.redraw();
        }
        /**
         * The up/down arrow handler for time inputs
         * @param {Event} e the click event
         */
        function timeIncrement(e) {
            var eventTarget = getEventTarget(e);
            if (~eventTarget.className.indexOf("arrow"))
                incrementNumInput(e, eventTarget.classList.contains("arrowUp") ? 1 : -1);
        }
        /**
         * Increments/decrements the value of input associ-
         * ated with the up/down arrow by dispatching an
         * "increment" event on the input.
         *
         * @param {Event} e the click event
         * @param {Number} delta the diff (usually 1 or -1)
         * @param {Element} inputElem the input element
         */
        function incrementNumInput(e, delta, inputElem) {
            var target = e && getEventTarget(e);
            var input = inputElem ||
                (target && target.parentNode && target.parentNode.firstChild);
            var event = createEvent("increment");
            event.delta = delta;
            input && input.dispatchEvent(event);
        }
        function build() {
            var fragment = window.document.createDocumentFragment();
            self.calendarContainer = createElement("div", "flatpickr-calendar");
            self.calendarContainer.tabIndex = -1;
            if (!self.config.noCalendar) {
                fragment.appendChild(buildMonthNav());
                self.innerContainer = createElement("div", "flatpickr-innerContainer");
                if (self.config.weekNumbers) {
                    var _a = buildWeeks(), weekWrapper = _a.weekWrapper, weekNumbers = _a.weekNumbers;
                    self.innerContainer.appendChild(weekWrapper);
                    self.weekNumbers = weekNumbers;
                    self.weekWrapper = weekWrapper;
                }
                self.rContainer = createElement("div", "flatpickr-rContainer");
                self.rContainer.appendChild(buildWeekdays());
                if (!self.daysContainer) {
                    self.daysContainer = createElement("div", "flatpickr-days");
                    self.daysContainer.tabIndex = -1;
                }
                buildDays();
                self.rContainer.appendChild(self.daysContainer);
                self.innerContainer.appendChild(self.rContainer);
                fragment.appendChild(self.innerContainer);
            }
            if (self.config.enableTime) {
                fragment.appendChild(buildTime());
            }
            toggleClass(self.calendarContainer, "rangeMode", self.config.mode === "range");
            toggleClass(self.calendarContainer, "animate", self.config.animate === true);
            toggleClass(self.calendarContainer, "multiMonth", self.config.showMonths > 1);
            self.calendarContainer.appendChild(fragment);
            var customAppend = self.config.appendTo !== undefined &&
                self.config.appendTo.nodeType !== undefined;
            if (self.config.inline || self.config.static) {
                self.calendarContainer.classList.add(self.config.inline ? "inline" : "static");
                if (self.config.inline) {
                    if (!customAppend && self.element.parentNode)
                        self.element.parentNode.insertBefore(self.calendarContainer, self._input.nextSibling);
                    else if (self.config.appendTo !== undefined)
                        self.config.appendTo.appendChild(self.calendarContainer);
                }
                if (self.config.static) {
                    var wrapper = createElement("div", "flatpickr-wrapper");
                    if (self.element.parentNode)
                        self.element.parentNode.insertBefore(wrapper, self.element);
                    wrapper.appendChild(self.element);
                    if (self.altInput)
                        wrapper.appendChild(self.altInput);
                    wrapper.appendChild(self.calendarContainer);
                }
            }
            if (!self.config.static && !self.config.inline)
                (self.config.appendTo !== undefined
                    ? self.config.appendTo
                    : window.document.body).appendChild(self.calendarContainer);
        }
        function createDay(className, date, dayNumber, i) {
            var dateIsEnabled = isEnabled(date, true), dayElement = createElement("span", className, date.getDate().toString());
            dayElement.dateObj = date;
            dayElement.$i = i;
            dayElement.setAttribute("aria-label", self.formatDate(date, self.config.ariaDateFormat));
            if (className.indexOf("hidden") === -1 &&
                compareDates(date, self.now) === 0) {
                self.todayDateElem = dayElement;
                dayElement.classList.add("today");
                dayElement.setAttribute("aria-current", "date");
            }
            if (dateIsEnabled) {
                dayElement.tabIndex = -1;
                if (isDateSelected(date)) {
                    dayElement.classList.add("selected");
                    self.selectedDateElem = dayElement;
                    if (self.config.mode === "range") {
                        toggleClass(dayElement, "startRange", self.selectedDates[0] &&
                            compareDates(date, self.selectedDates[0], true) === 0);
                        toggleClass(dayElement, "endRange", self.selectedDates[1] &&
                            compareDates(date, self.selectedDates[1], true) === 0);
                        if (className === "nextMonthDay")
                            dayElement.classList.add("inRange");
                    }
                }
            }
            else {
                dayElement.classList.add("flatpickr-disabled");
            }
            if (self.config.mode === "range") {
                if (isDateInRange(date) && !isDateSelected(date))
                    dayElement.classList.add("inRange");
            }
            if (self.weekNumbers &&
                self.config.showMonths === 1 &&
                className !== "prevMonthDay" &&
                dayNumber % 7 === 1) {
                self.weekNumbers.insertAdjacentHTML("beforeend", "<span class='flatpickr-day'>" + self.config.getWeek(date) + "</span>");
            }
            triggerEvent("onDayCreate", dayElement);
            return dayElement;
        }
        function focusOnDayElem(targetNode) {
            targetNode.focus();
            if (self.config.mode === "range")
                onMouseOver(targetNode);
        }
        function getFirstAvailableDay(delta) {
            var startMonth = delta > 0 ? 0 : self.config.showMonths - 1;
            var endMonth = delta > 0 ? self.config.showMonths : -1;
            for (var m = startMonth; m != endMonth; m += delta) {
                var month = self.daysContainer.children[m];
                var startIndex = delta > 0 ? 0 : month.children.length - 1;
                var endIndex = delta > 0 ? month.children.length : -1;
                for (var i = startIndex; i != endIndex; i += delta) {
                    var c = month.children[i];
                    if (c.className.indexOf("hidden") === -1 && isEnabled(c.dateObj))
                        return c;
                }
            }
            return undefined;
        }
        function getNextAvailableDay(current, delta) {
            var givenMonth = current.className.indexOf("Month") === -1
                ? current.dateObj.getMonth()
                : self.currentMonth;
            var endMonth = delta > 0 ? self.config.showMonths : -1;
            var loopDelta = delta > 0 ? 1 : -1;
            for (var m = givenMonth - self.currentMonth; m != endMonth; m += loopDelta) {
                var month = self.daysContainer.children[m];
                var startIndex = givenMonth - self.currentMonth === m
                    ? current.$i + delta
                    : delta < 0
                        ? month.children.length - 1
                        : 0;
                var numMonthDays = month.children.length;
                for (var i = startIndex; i >= 0 && i < numMonthDays && i != (delta > 0 ? numMonthDays : -1); i += loopDelta) {
                    var c = month.children[i];
                    if (c.className.indexOf("hidden") === -1 &&
                        isEnabled(c.dateObj) &&
                        Math.abs(current.$i - i) >= Math.abs(delta))
                        return focusOnDayElem(c);
                }
            }
            self.changeMonth(loopDelta);
            focusOnDay(getFirstAvailableDay(loopDelta), 0);
            return undefined;
        }
        function focusOnDay(current, offset) {
            var activeElement = getClosestActiveElement();
            var dayFocused = isInView(activeElement || document.body);
            var startElem = current !== undefined
                ? current
                : dayFocused
                    ? activeElement
                    : self.selectedDateElem !== undefined && isInView(self.selectedDateElem)
                        ? self.selectedDateElem
                        : self.todayDateElem !== undefined && isInView(self.todayDateElem)
                            ? self.todayDateElem
                            : getFirstAvailableDay(offset > 0 ? 1 : -1);
            if (startElem === undefined) {
                self._input.focus();
            }
            else if (!dayFocused) {
                focusOnDayElem(startElem);
            }
            else {
                getNextAvailableDay(startElem, offset);
            }
        }
        function buildMonthDays(year, month) {
            var firstOfMonth = (new Date(year, month, 1).getDay() - self.l10n.firstDayOfWeek + 7) % 7;
            var prevMonthDays = self.utils.getDaysInMonth((month - 1 + 12) % 12, year);
            var daysInMonth = self.utils.getDaysInMonth(month, year), days = window.document.createDocumentFragment(), isMultiMonth = self.config.showMonths > 1, prevMonthDayClass = isMultiMonth ? "prevMonthDay hidden" : "prevMonthDay", nextMonthDayClass = isMultiMonth ? "nextMonthDay hidden" : "nextMonthDay";
            var dayNumber = prevMonthDays + 1 - firstOfMonth, dayIndex = 0;
            // prepend days from the ending of previous month
            for (; dayNumber <= prevMonthDays; dayNumber++, dayIndex++) {
                days.appendChild(createDay("flatpickr-day " + prevMonthDayClass, new Date(year, month - 1, dayNumber), dayNumber, dayIndex));
            }
            // Start at 1 since there is no 0th day
            for (dayNumber = 1; dayNumber <= daysInMonth; dayNumber++, dayIndex++) {
                days.appendChild(createDay("flatpickr-day", new Date(year, month, dayNumber), dayNumber, dayIndex));
            }
            // append days from the next month
            for (var dayNum = daysInMonth + 1; dayNum <= 42 - firstOfMonth &&
                (self.config.showMonths === 1 || dayIndex % 7 !== 0); dayNum++, dayIndex++) {
                days.appendChild(createDay("flatpickr-day " + nextMonthDayClass, new Date(year, month + 1, dayNum % daysInMonth), dayNum, dayIndex));
            }
            //updateNavigationCurrentMonth();
            var dayContainer = createElement("div", "dayContainer");
            dayContainer.appendChild(days);
            return dayContainer;
        }
        function buildDays() {
            if (self.daysContainer === undefined) {
                return;
            }
            clearNode(self.daysContainer);
            // TODO: week numbers for each month
            if (self.weekNumbers)
                clearNode(self.weekNumbers);
            var frag = document.createDocumentFragment();
            for (var i = 0; i < self.config.showMonths; i++) {
                var d = new Date(self.currentYear, self.currentMonth, 1);
                d.setMonth(self.currentMonth + i);
                frag.appendChild(buildMonthDays(d.getFullYear(), d.getMonth()));
            }
            self.daysContainer.appendChild(frag);
            self.days = self.daysContainer.firstChild;
            if (self.config.mode === "range" && self.selectedDates.length === 1) {
                onMouseOver();
            }
        }
        function buildMonthSwitch() {
            if (self.config.showMonths > 1 ||
                self.config.monthSelectorType !== "dropdown")
                return;
            var shouldBuildMonth = function (month) {
                if (self.config.minDate !== undefined &&
                    self.currentYear === self.config.minDate.getFullYear() &&
                    month < self.config.minDate.getMonth()) {
                    return false;
                }
                return !(self.config.maxDate !== undefined &&
                    self.currentYear === self.config.maxDate.getFullYear() &&
                    month > self.config.maxDate.getMonth());
            };
            self.monthsDropdownContainer.tabIndex = -1;
            self.monthsDropdownContainer.innerHTML = "";
            for (var i = 0; i < 12; i++) {
                if (!shouldBuildMonth(i))
                    continue;
                var month = createElement("option", "flatpickr-monthDropdown-month");
                month.value = new Date(self.currentYear, i).getMonth().toString();
                month.textContent = monthToStr(i, self.config.shorthandCurrentMonth, self.l10n);
                month.tabIndex = -1;
                if (self.currentMonth === i) {
                    month.selected = true;
                }
                self.monthsDropdownContainer.appendChild(month);
            }
        }
        function buildMonth() {
            var container = createElement("div", "flatpickr-month");
            var monthNavFragment = window.document.createDocumentFragment();
            var monthElement;
            if (self.config.showMonths > 1 ||
                self.config.monthSelectorType === "static") {
                monthElement = createElement("span", "cur-month");
            }
            else {
                self.monthsDropdownContainer = createElement("select", "flatpickr-monthDropdown-months");
                self.monthsDropdownContainer.setAttribute("aria-label", self.l10n.monthAriaLabel);
                bind(self.monthsDropdownContainer, "change", function (e) {
                    var target = getEventTarget(e);
                    var selectedMonth = parseInt(target.value, 10);
                    self.changeMonth(selectedMonth - self.currentMonth);
                    triggerEvent("onMonthChange");
                });
                buildMonthSwitch();
                monthElement = self.monthsDropdownContainer;
            }
            var yearInput = createNumberInput("cur-year", { tabindex: "-1" });
            var yearElement = yearInput.getElementsByTagName("input")[0];
            yearElement.setAttribute("aria-label", self.l10n.yearAriaLabel);
            if (self.config.minDate) {
                yearElement.setAttribute("min", self.config.minDate.getFullYear().toString());
            }
            if (self.config.maxDate) {
                yearElement.setAttribute("max", self.config.maxDate.getFullYear().toString());
                yearElement.disabled =
                    !!self.config.minDate &&
                        self.config.minDate.getFullYear() === self.config.maxDate.getFullYear();
            }
            var currentMonth = createElement("div", "flatpickr-current-month");
            currentMonth.appendChild(monthElement);
            currentMonth.appendChild(yearInput);
            monthNavFragment.appendChild(currentMonth);
            container.appendChild(monthNavFragment);
            return {
                container: container,
                yearElement: yearElement,
                monthElement: monthElement,
            };
        }
        function buildMonths() {
            clearNode(self.monthNav);
            self.monthNav.appendChild(self.prevMonthNav);
            if (self.config.showMonths) {
                self.yearElements = [];
                self.monthElements = [];
            }
            for (var m = self.config.showMonths; m--;) {
                var month = buildMonth();
                self.yearElements.push(month.yearElement);
                self.monthElements.push(month.monthElement);
                self.monthNav.appendChild(month.container);
            }
            self.monthNav.appendChild(self.nextMonthNav);
        }
        function buildMonthNav() {
            self.monthNav = createElement("div", "flatpickr-months");
            self.yearElements = [];
            self.monthElements = [];
            self.prevMonthNav = createElement("span", "flatpickr-prev-month");
            self.prevMonthNav.innerHTML = self.config.prevArrow;
            self.nextMonthNav = createElement("span", "flatpickr-next-month");
            self.nextMonthNav.innerHTML = self.config.nextArrow;
            buildMonths();
            Object.defineProperty(self, "_hidePrevMonthArrow", {
                get: function () { return self.__hidePrevMonthArrow; },
                set: function (bool) {
                    if (self.__hidePrevMonthArrow !== bool) {
                        toggleClass(self.prevMonthNav, "flatpickr-disabled", bool);
                        self.__hidePrevMonthArrow = bool;
                    }
                },
            });
            Object.defineProperty(self, "_hideNextMonthArrow", {
                get: function () { return self.__hideNextMonthArrow; },
                set: function (bool) {
                    if (self.__hideNextMonthArrow !== bool) {
                        toggleClass(self.nextMonthNav, "flatpickr-disabled", bool);
                        self.__hideNextMonthArrow = bool;
                    }
                },
            });
            self.currentYearElement = self.yearElements[0];
            updateNavigationCurrentMonth();
            return self.monthNav;
        }
        function buildTime() {
            self.calendarContainer.classList.add("hasTime");
            if (self.config.noCalendar)
                self.calendarContainer.classList.add("noCalendar");
            var defaults = getDefaultHours(self.config);
            self.timeContainer = createElement("div", "flatpickr-time");
            self.timeContainer.tabIndex = -1;
            var separator = createElement("span", "flatpickr-time-separator", ":");
            var hourInput = createNumberInput("flatpickr-hour", {
                "aria-label": self.l10n.hourAriaLabel,
            });
            self.hourElement = hourInput.getElementsByTagName("input")[0];
            var minuteInput = createNumberInput("flatpickr-minute", {
                "aria-label": self.l10n.minuteAriaLabel,
            });
            self.minuteElement = minuteInput.getElementsByTagName("input")[0];
            self.hourElement.tabIndex = self.minuteElement.tabIndex = -1;
            self.hourElement.value = pad(self.latestSelectedDateObj
                ? self.latestSelectedDateObj.getHours()
                : self.config.time_24hr
                    ? defaults.hours
                    : military2ampm(defaults.hours));
            self.minuteElement.value = pad(self.latestSelectedDateObj
                ? self.latestSelectedDateObj.getMinutes()
                : defaults.minutes);
            self.hourElement.setAttribute("step", self.config.hourIncrement.toString());
            self.minuteElement.setAttribute("step", self.config.minuteIncrement.toString());
            self.hourElement.setAttribute("min", self.config.time_24hr ? "0" : "1");
            self.hourElement.setAttribute("max", self.config.time_24hr ? "23" : "12");
            self.hourElement.setAttribute("maxlength", "2");
            self.minuteElement.setAttribute("min", "0");
            self.minuteElement.setAttribute("max", "59");
            self.minuteElement.setAttribute("maxlength", "2");
            self.timeContainer.appendChild(hourInput);
            self.timeContainer.appendChild(separator);
            self.timeContainer.appendChild(minuteInput);
            if (self.config.time_24hr)
                self.timeContainer.classList.add("time24hr");
            if (self.config.enableSeconds) {
                self.timeContainer.classList.add("hasSeconds");
                var secondInput = createNumberInput("flatpickr-second");
                self.secondElement = secondInput.getElementsByTagName("input")[0];
                self.secondElement.value = pad(self.latestSelectedDateObj
                    ? self.latestSelectedDateObj.getSeconds()
                    : defaults.seconds);
                self.secondElement.setAttribute("step", self.minuteElement.getAttribute("step"));
                self.secondElement.setAttribute("min", "0");
                self.secondElement.setAttribute("max", "59");
                self.secondElement.setAttribute("maxlength", "2");
                self.timeContainer.appendChild(createElement("span", "flatpickr-time-separator", ":"));
                self.timeContainer.appendChild(secondInput);
            }
            if (!self.config.time_24hr) {
                // add self.amPM if appropriate
                self.amPM = createElement("span", "flatpickr-am-pm", self.l10n.amPM[int((self.latestSelectedDateObj
                    ? self.hourElement.value
                    : self.config.defaultHour) > 11)]);
                self.amPM.title = self.l10n.toggleTitle;
                self.amPM.tabIndex = -1;
                self.timeContainer.appendChild(self.amPM);
            }
            return self.timeContainer;
        }
        function buildWeekdays() {
            if (!self.weekdayContainer)
                self.weekdayContainer = createElement("div", "flatpickr-weekdays");
            else
                clearNode(self.weekdayContainer);
            for (var i = self.config.showMonths; i--;) {
                var container = createElement("div", "flatpickr-weekdaycontainer");
                self.weekdayContainer.appendChild(container);
            }
            updateWeekdays();
            return self.weekdayContainer;
        }
        function updateWeekdays() {
            if (!self.weekdayContainer) {
                return;
            }
            var firstDayOfWeek = self.l10n.firstDayOfWeek;
            var weekdays = __spreadArrays(self.l10n.weekdays.shorthand);
            if (firstDayOfWeek > 0 && firstDayOfWeek < weekdays.length) {
                weekdays = __spreadArrays(weekdays.splice(firstDayOfWeek, weekdays.length), weekdays.splice(0, firstDayOfWeek));
            }
            for (var i = self.config.showMonths; i--;) {
                self.weekdayContainer.children[i].innerHTML = "\n      <span class='flatpickr-weekday'>\n        " + weekdays.join("</span><span class='flatpickr-weekday'>") + "\n      </span>\n      ";
            }
        }
        /* istanbul ignore next */
        function buildWeeks() {
            self.calendarContainer.classList.add("hasWeeks");
            var weekWrapper = createElement("div", "flatpickr-weekwrapper");
            weekWrapper.appendChild(createElement("span", "flatpickr-weekday", self.l10n.weekAbbreviation));
            var weekNumbers = createElement("div", "flatpickr-weeks");
            weekWrapper.appendChild(weekNumbers);
            return {
                weekWrapper: weekWrapper,
                weekNumbers: weekNumbers,
            };
        }
        function changeMonth(value, isOffset) {
            if (isOffset === void 0) { isOffset = true; }
            var delta = isOffset ? value : value - self.currentMonth;
            if ((delta < 0 && self._hidePrevMonthArrow === true) ||
                (delta > 0 && self._hideNextMonthArrow === true))
                return;
            self.currentMonth += delta;
            if (self.currentMonth < 0 || self.currentMonth > 11) {
                self.currentYear += self.currentMonth > 11 ? 1 : -1;
                self.currentMonth = (self.currentMonth + 12) % 12;
                triggerEvent("onYearChange");
                buildMonthSwitch();
            }
            buildDays();
            triggerEvent("onMonthChange");
            updateNavigationCurrentMonth();
        }
        function clear(triggerChangeEvent, toInitial) {
            if (triggerChangeEvent === void 0) { triggerChangeEvent = true; }
            if (toInitial === void 0) { toInitial = true; }
            self.input.value = "";
            if (self.altInput !== undefined)
                self.altInput.value = "";
            if (self.mobileInput !== undefined)
                self.mobileInput.value = "";
            self.selectedDates = [];
            self.latestSelectedDateObj = undefined;
            if (toInitial === true) {
                self.currentYear = self._initialDate.getFullYear();
                self.currentMonth = self._initialDate.getMonth();
            }
            if (self.config.enableTime === true) {
                var _a = getDefaultHours(self.config), hours = _a.hours, minutes = _a.minutes, seconds = _a.seconds;
                setHours(hours, minutes, seconds);
            }
            self.redraw();
            if (triggerChangeEvent)
                // triggerChangeEvent is true (default) or an Event
                triggerEvent("onChange");
        }
        function close() {
            self.isOpen = false;
            if (!self.isMobile) {
                if (self.calendarContainer !== undefined) {
                    self.calendarContainer.classList.remove("open");
                }
                if (self._input !== undefined) {
                    self._input.classList.remove("active");
                }
            }
            triggerEvent("onClose");
        }
        function destroy() {
            if (self.config !== undefined)
                triggerEvent("onDestroy");
            for (var i = self._handlers.length; i--;) {
                self._handlers[i].remove();
            }
            self._handlers = [];
            if (self.mobileInput) {
                if (self.mobileInput.parentNode)
                    self.mobileInput.parentNode.removeChild(self.mobileInput);
                self.mobileInput = undefined;
            }
            else if (self.calendarContainer && self.calendarContainer.parentNode) {
                if (self.config.static && self.calendarContainer.parentNode) {
                    var wrapper = self.calendarContainer.parentNode;
                    wrapper.lastChild && wrapper.removeChild(wrapper.lastChild);
                    if (wrapper.parentNode) {
                        while (wrapper.firstChild)
                            wrapper.parentNode.insertBefore(wrapper.firstChild, wrapper);
                        wrapper.parentNode.removeChild(wrapper);
                    }
                }
                else
                    self.calendarContainer.parentNode.removeChild(self.calendarContainer);
            }
            if (self.altInput) {
                self.input.type = "text";
                if (self.altInput.parentNode)
                    self.altInput.parentNode.removeChild(self.altInput);
                delete self.altInput;
            }
            if (self.input) {
                self.input.type = self.input._type;
                self.input.classList.remove("flatpickr-input");
                self.input.removeAttribute("readonly");
            }
            [
                "_showTimeInput",
                "latestSelectedDateObj",
                "_hideNextMonthArrow",
                "_hidePrevMonthArrow",
                "__hideNextMonthArrow",
                "__hidePrevMonthArrow",
                "isMobile",
                "isOpen",
                "selectedDateElem",
                "minDateHasTime",
                "maxDateHasTime",
                "days",
                "daysContainer",
                "_input",
                "_positionElement",
                "innerContainer",
                "rContainer",
                "monthNav",
                "todayDateElem",
                "calendarContainer",
                "weekdayContainer",
                "prevMonthNav",
                "nextMonthNav",
                "monthsDropdownContainer",
                "currentMonthElement",
                "currentYearElement",
                "navigationCurrentMonth",
                "selectedDateElem",
                "config",
            ].forEach(function (k) {
                try {
                    delete self[k];
                }
                catch (_) { }
            });
        }
        function isCalendarElem(elem) {
            return self.calendarContainer.contains(elem);
        }
        function documentClick(e) {
            if (self.isOpen && !self.config.inline) {
                var eventTarget_1 = getEventTarget(e);
                var isCalendarElement = isCalendarElem(eventTarget_1);
                var isInput = eventTarget_1 === self.input ||
                    eventTarget_1 === self.altInput ||
                    self.element.contains(eventTarget_1) ||
                    // web components
                    // e.path is not present in all browsers. circumventing typechecks
                    (e.path &&
                        e.path.indexOf &&
                        (~e.path.indexOf(self.input) ||
                            ~e.path.indexOf(self.altInput)));
                var lostFocus = !isInput &&
                    !isCalendarElement &&
                    !isCalendarElem(e.relatedTarget);
                var isIgnored = !self.config.ignoredFocusElements.some(function (elem) {
                    return elem.contains(eventTarget_1);
                });
                if (lostFocus && isIgnored) {
                    if (self.config.allowInput) {
                        self.setDate(self._input.value, false, self.config.altInput
                            ? self.config.altFormat
                            : self.config.dateFormat);
                    }
                    if (self.timeContainer !== undefined &&
                        self.minuteElement !== undefined &&
                        self.hourElement !== undefined &&
                        self.input.value !== "" &&
                        self.input.value !== undefined) {
                        updateTime();
                    }
                    self.close();
                    if (self.config &&
                        self.config.mode === "range" &&
                        self.selectedDates.length === 1)
                        self.clear(false);
                }
            }
        }
        function changeYear(newYear) {
            if (!newYear ||
                (self.config.minDate && newYear < self.config.minDate.getFullYear()) ||
                (self.config.maxDate && newYear > self.config.maxDate.getFullYear()))
                return;
            var newYearNum = newYear, isNewYear = self.currentYear !== newYearNum;
            self.currentYear = newYearNum || self.currentYear;
            if (self.config.maxDate &&
                self.currentYear === self.config.maxDate.getFullYear()) {
                self.currentMonth = Math.min(self.config.maxDate.getMonth(), self.currentMonth);
            }
            else if (self.config.minDate &&
                self.currentYear === self.config.minDate.getFullYear()) {
                self.currentMonth = Math.max(self.config.minDate.getMonth(), self.currentMonth);
            }
            if (isNewYear) {
                self.redraw();
                triggerEvent("onYearChange");
                buildMonthSwitch();
            }
        }
        function isEnabled(date, timeless) {
            var _a;
            if (timeless === void 0) { timeless = true; }
            var dateToCheck = self.parseDate(date, undefined, timeless); // timeless
            if ((self.config.minDate &&
                dateToCheck &&
                compareDates(dateToCheck, self.config.minDate, timeless !== undefined ? timeless : !self.minDateHasTime) < 0) ||
                (self.config.maxDate &&
                    dateToCheck &&
                    compareDates(dateToCheck, self.config.maxDate, timeless !== undefined ? timeless : !self.maxDateHasTime) > 0))
                return false;
            if (!self.config.enable && self.config.disable.length === 0)
                return true;
            if (dateToCheck === undefined)
                return false;
            var bool = !!self.config.enable, array = (_a = self.config.enable) !== null && _a !== void 0 ? _a : self.config.disable;
            for (var i = 0, d = void 0; i < array.length; i++) {
                d = array[i];
                if (typeof d === "function" &&
                    d(dateToCheck) // disabled by function
                )
                    return bool;
                else if (d instanceof Date &&
                    dateToCheck !== undefined &&
                    d.getTime() === dateToCheck.getTime())
                    // disabled by date
                    return bool;
                else if (typeof d === "string") {
                    // disabled by date string
                    var parsed = self.parseDate(d, undefined, true);
                    return parsed && parsed.getTime() === dateToCheck.getTime()
                        ? bool
                        : !bool;
                }
                else if (
                // disabled by range
                typeof d === "object" &&
                    dateToCheck !== undefined &&
                    d.from &&
                    d.to &&
                    dateToCheck.getTime() >= d.from.getTime() &&
                    dateToCheck.getTime() <= d.to.getTime())
                    return bool;
            }
            return !bool;
        }
        function isInView(elem) {
            if (self.daysContainer !== undefined)
                return (elem.className.indexOf("hidden") === -1 &&
                    elem.className.indexOf("flatpickr-disabled") === -1 &&
                    self.daysContainer.contains(elem));
            return false;
        }
        function onBlur(e) {
            var isInput = e.target === self._input;
            if (isInput &&
                (self.selectedDates.length > 0 || self._input.value.length > 0) &&
                !(e.relatedTarget && isCalendarElem(e.relatedTarget))) {
                self.setDate(self._input.value, true, e.target === self.altInput
                    ? self.config.altFormat
                    : self.config.dateFormat);
            }
        }
        function onKeyDown(e) {
            // e.key                      e.keyCode
            // "Backspace"                        8
            // "Tab"                              9
            // "Enter"                           13
            // "Escape"     (IE "Esc")           27
            // "ArrowLeft"  (IE "Left")          37
            // "ArrowUp"    (IE "Up")            38
            // "ArrowRight" (IE "Right")         39
            // "ArrowDown"  (IE "Down")          40
            // "Delete"     (IE "Del")           46
            var eventTarget = getEventTarget(e);
            var isInput = self.config.wrap
                ? element.contains(eventTarget)
                : eventTarget === self._input;
            var allowInput = self.config.allowInput;
            var allowKeydown = self.isOpen && (!allowInput || !isInput);
            var allowInlineKeydown = self.config.inline && isInput && !allowInput;
            if (e.keyCode === 13 && isInput) {
                if (allowInput) {
                    self.setDate(self._input.value, true, eventTarget === self.altInput
                        ? self.config.altFormat
                        : self.config.dateFormat);
                    self.close();
                    return eventTarget.blur();
                }
                else {
                    self.open();
                }
            }
            else if (isCalendarElem(eventTarget) ||
                allowKeydown ||
                allowInlineKeydown) {
                var isTimeObj = !!self.timeContainer &&
                    self.timeContainer.contains(eventTarget);
                switch (e.keyCode) {
                    case 13:
                        if (isTimeObj) {
                            e.preventDefault();
                            updateTime();
                            focusAndClose();
                        }
                        else
                            selectDate(e);
                        break;
                    case 27: // escape
                        e.preventDefault();
                        focusAndClose();
                        break;
                    case 8:
                    case 46:
                        if (isInput && !self.config.allowInput) {
                            e.preventDefault();
                            self.clear();
                        }
                        break;
                    case 37:
                    case 39:
                        if (!isTimeObj && !isInput) {
                            e.preventDefault();
                            var activeElement = getClosestActiveElement();
                            if (self.daysContainer !== undefined &&
                                (allowInput === false ||
                                    (activeElement && isInView(activeElement)))) {
                                var delta_1 = e.keyCode === 39 ? 1 : -1;
                                if (!e.ctrlKey)
                                    focusOnDay(undefined, delta_1);
                                else {
                                    e.stopPropagation();
                                    changeMonth(delta_1);
                                    focusOnDay(getFirstAvailableDay(1), 0);
                                }
                            }
                        }
                        else if (self.hourElement)
                            self.hourElement.focus();
                        break;
                    case 38:
                    case 40:
                        e.preventDefault();
                        var delta = e.keyCode === 40 ? 1 : -1;
                        if ((self.daysContainer &&
                            eventTarget.$i !== undefined) ||
                            eventTarget === self.input ||
                            eventTarget === self.altInput) {
                            if (e.ctrlKey) {
                                e.stopPropagation();
                                changeYear(self.currentYear - delta);
                                focusOnDay(getFirstAvailableDay(1), 0);
                            }
                            else if (!isTimeObj)
                                focusOnDay(undefined, delta * 7);
                        }
                        else if (eventTarget === self.currentYearElement) {
                            changeYear(self.currentYear - delta);
                        }
                        else if (self.config.enableTime) {
                            if (!isTimeObj && self.hourElement)
                                self.hourElement.focus();
                            updateTime(e);
                            self._debouncedChange();
                        }
                        break;
                    case 9:
                        if (isTimeObj) {
                            var elems = [
                                self.hourElement,
                                self.minuteElement,
                                self.secondElement,
                                self.amPM,
                            ]
                                .concat(self.pluginElements)
                                .filter(function (x) { return x; });
                            var i = elems.indexOf(eventTarget);
                            if (i !== -1) {
                                var target = elems[i + (e.shiftKey ? -1 : 1)];
                                e.preventDefault();
                                (target || self._input).focus();
                            }
                        }
                        else if (!self.config.noCalendar &&
                            self.daysContainer &&
                            self.daysContainer.contains(eventTarget) &&
                            e.shiftKey) {
                            e.preventDefault();
                            self._input.focus();
                        }
                        break;
                }
            }
            if (self.amPM !== undefined && eventTarget === self.amPM) {
                switch (e.key) {
                    case self.l10n.amPM[0].charAt(0):
                    case self.l10n.amPM[0].charAt(0).toLowerCase():
                        self.amPM.textContent = self.l10n.amPM[0];
                        setHoursFromInputs();
                        updateValue();
                        break;
                    case self.l10n.amPM[1].charAt(0):
                    case self.l10n.amPM[1].charAt(0).toLowerCase():
                        self.amPM.textContent = self.l10n.amPM[1];
                        setHoursFromInputs();
                        updateValue();
                        break;
                }
            }
            if (isInput || isCalendarElem(eventTarget)) {
                triggerEvent("onKeyDown", e);
            }
        }
        function onMouseOver(elem, cellClass) {
            if (cellClass === void 0) { cellClass = "flatpickr-day"; }
            if (self.selectedDates.length !== 1 ||
                (elem &&
                    (!elem.classList.contains(cellClass) ||
                        elem.classList.contains("flatpickr-disabled"))))
                return;
            var hoverDate = elem
                ? elem.dateObj.getTime()
                : self.days.firstElementChild.dateObj.getTime(), initialDate = self.parseDate(self.selectedDates[0], undefined, true).getTime(), rangeStartDate = Math.min(hoverDate, self.selectedDates[0].getTime()), rangeEndDate = Math.max(hoverDate, self.selectedDates[0].getTime());
            var containsDisabled = false;
            var minRange = 0, maxRange = 0;
            for (var t = rangeStartDate; t < rangeEndDate; t += duration.DAY) {
                if (!isEnabled(new Date(t), true)) {
                    containsDisabled =
                        containsDisabled || (t > rangeStartDate && t < rangeEndDate);
                    if (t < initialDate && (!minRange || t > minRange))
                        minRange = t;
                    else if (t > initialDate && (!maxRange || t < maxRange))
                        maxRange = t;
                }
            }
            var hoverableCells = Array.from(self.rContainer.querySelectorAll("*:nth-child(-n+" + self.config.showMonths + ") > ." + cellClass));
            hoverableCells.forEach(function (dayElem) {
                var date = dayElem.dateObj;
                var timestamp = date.getTime();
                var outOfRange = (minRange > 0 && timestamp < minRange) ||
                    (maxRange > 0 && timestamp > maxRange);
                if (outOfRange) {
                    dayElem.classList.add("notAllowed");
                    ["inRange", "startRange", "endRange"].forEach(function (c) {
                        dayElem.classList.remove(c);
                    });
                    return;
                }
                else if (containsDisabled && !outOfRange)
                    return;
                ["startRange", "inRange", "endRange", "notAllowed"].forEach(function (c) {
                    dayElem.classList.remove(c);
                });
                if (elem !== undefined) {
                    elem.classList.add(hoverDate <= self.selectedDates[0].getTime()
                        ? "startRange"
                        : "endRange");
                    if (initialDate < hoverDate && timestamp === initialDate)
                        dayElem.classList.add("startRange");
                    else if (initialDate > hoverDate && timestamp === initialDate)
                        dayElem.classList.add("endRange");
                    if (timestamp >= minRange &&
                        (maxRange === 0 || timestamp <= maxRange) &&
                        isBetween(timestamp, initialDate, hoverDate))
                        dayElem.classList.add("inRange");
                }
            });
        }
        function onResize() {
            if (self.isOpen && !self.config.static && !self.config.inline)
                positionCalendar();
        }
        function open(e, positionElement) {
            if (positionElement === void 0) { positionElement = self._positionElement; }
            if (self.isMobile === true) {
                if (e) {
                    e.preventDefault();
                    var eventTarget = getEventTarget(e);
                    if (eventTarget) {
                        eventTarget.blur();
                    }
                }
                if (self.mobileInput !== undefined) {
                    self.mobileInput.focus();
                    self.mobileInput.click();
                }
                triggerEvent("onOpen");
                return;
            }
            else if (self._input.disabled || self.config.inline) {
                return;
            }
            var wasOpen = self.isOpen;
            self.isOpen = true;
            if (!wasOpen) {
                self.calendarContainer.classList.add("open");
                self._input.classList.add("active");
                triggerEvent("onOpen");
                positionCalendar(positionElement);
            }
            if (self.config.enableTime === true && self.config.noCalendar === true) {
                if (self.config.allowInput === false &&
                    (e === undefined ||
                        !self.timeContainer.contains(e.relatedTarget))) {
                    setTimeout(function () { return self.hourElement.select(); }, 50);
                }
            }
        }
        function minMaxDateSetter(type) {
            return function (date) {
                var dateObj = (self.config["_" + type + "Date"] = self.parseDate(date, self.config.dateFormat));
                var inverseDateObj = self.config["_" + (type === "min" ? "max" : "min") + "Date"];
                if (dateObj !== undefined) {
                    self[type === "min" ? "minDateHasTime" : "maxDateHasTime"] =
                        dateObj.getHours() > 0 ||
                            dateObj.getMinutes() > 0 ||
                            dateObj.getSeconds() > 0;
                }
                if (self.selectedDates) {
                    self.selectedDates = self.selectedDates.filter(function (d) { return isEnabled(d); });
                    if (!self.selectedDates.length && type === "min")
                        setHoursFromDate(dateObj);
                    updateValue();
                }
                if (self.daysContainer) {
                    redraw();
                    if (dateObj !== undefined)
                        self.currentYearElement[type] = dateObj.getFullYear().toString();
                    else
                        self.currentYearElement.removeAttribute(type);
                    self.currentYearElement.disabled =
                        !!inverseDateObj &&
                            dateObj !== undefined &&
                            inverseDateObj.getFullYear() === dateObj.getFullYear();
                }
            };
        }
        function parseConfig() {
            var boolOpts = [
                "wrap",
                "weekNumbers",
                "allowInput",
                "allowInvalidPreload",
                "clickOpens",
                "time_24hr",
                "enableTime",
                "noCalendar",
                "altInput",
                "shorthandCurrentMonth",
                "inline",
                "static",
                "enableSeconds",
                "disableMobile",
            ];
            var userConfig = __assign(__assign({}, JSON.parse(JSON.stringify(element.dataset || {}))), instanceConfig);
            var formats = {};
            self.config.parseDate = userConfig.parseDate;
            self.config.formatDate = userConfig.formatDate;
            Object.defineProperty(self.config, "enable", {
                get: function () { return self.config._enable; },
                set: function (dates) {
                    self.config._enable = parseDateRules(dates);
                },
            });
            Object.defineProperty(self.config, "disable", {
                get: function () { return self.config._disable; },
                set: function (dates) {
                    self.config._disable = parseDateRules(dates);
                },
            });
            var timeMode = userConfig.mode === "time";
            if (!userConfig.dateFormat && (userConfig.enableTime || timeMode)) {
                var defaultDateFormat = flatpickr.defaultConfig.dateFormat || defaults.dateFormat;
                formats.dateFormat =
                    userConfig.noCalendar || timeMode
                        ? "H:i" + (userConfig.enableSeconds ? ":S" : "")
                        : defaultDateFormat + " H:i" + (userConfig.enableSeconds ? ":S" : "");
            }
            if (userConfig.altInput &&
                (userConfig.enableTime || timeMode) &&
                !userConfig.altFormat) {
                var defaultAltFormat = flatpickr.defaultConfig.altFormat || defaults.altFormat;
                formats.altFormat =
                    userConfig.noCalendar || timeMode
                        ? "h:i" + (userConfig.enableSeconds ? ":S K" : " K")
                        : defaultAltFormat + (" h:i" + (userConfig.enableSeconds ? ":S" : "") + " K");
            }
            Object.defineProperty(self.config, "minDate", {
                get: function () { return self.config._minDate; },
                set: minMaxDateSetter("min"),
            });
            Object.defineProperty(self.config, "maxDate", {
                get: function () { return self.config._maxDate; },
                set: minMaxDateSetter("max"),
            });
            var minMaxTimeSetter = function (type) { return function (val) {
                self.config[type === "min" ? "_minTime" : "_maxTime"] = self.parseDate(val, "H:i:S");
            }; };
            Object.defineProperty(self.config, "minTime", {
                get: function () { return self.config._minTime; },
                set: minMaxTimeSetter("min"),
            });
            Object.defineProperty(self.config, "maxTime", {
                get: function () { return self.config._maxTime; },
                set: minMaxTimeSetter("max"),
            });
            if (userConfig.mode === "time") {
                self.config.noCalendar = true;
                self.config.enableTime = true;
            }
            Object.assign(self.config, formats, userConfig);
            for (var i = 0; i < boolOpts.length; i++)
                // https://github.com/microsoft/TypeScript/issues/31663
                self.config[boolOpts[i]] =
                    self.config[boolOpts[i]] === true ||
                        self.config[boolOpts[i]] === "true";
            HOOKS.filter(function (hook) { return self.config[hook] !== undefined; }).forEach(function (hook) {
                self.config[hook] = arrayify(self.config[hook] || []).map(bindToInstance);
            });
            self.isMobile =
                !self.config.disableMobile &&
                    !self.config.inline &&
                    self.config.mode === "single" &&
                    !self.config.disable.length &&
                    !self.config.enable &&
                    !self.config.weekNumbers &&
                    /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
            for (var i = 0; i < self.config.plugins.length; i++) {
                var pluginConf = self.config.plugins[i](self) || {};
                for (var key in pluginConf) {
                    if (HOOKS.indexOf(key) > -1) {
                        self.config[key] = arrayify(pluginConf[key])
                            .map(bindToInstance)
                            .concat(self.config[key]);
                    }
                    else if (typeof userConfig[key] === "undefined")
                        self.config[key] = pluginConf[key];
                }
            }
            if (!userConfig.altInputClass) {
                self.config.altInputClass =
                    getInputElem().className + " " + self.config.altInputClass;
            }
            triggerEvent("onParseConfig");
        }
        function getInputElem() {
            return self.config.wrap
                ? element.querySelector("[data-input]")
                : element;
        }
        function setupLocale() {
            if (typeof self.config.locale !== "object" &&
                typeof flatpickr.l10ns[self.config.locale] === "undefined")
                self.config.errorHandler(new Error("flatpickr: invalid locale " + self.config.locale));
            self.l10n = __assign(__assign({}, flatpickr.l10ns.default), (typeof self.config.locale === "object"
                ? self.config.locale
                : self.config.locale !== "default"
                    ? flatpickr.l10ns[self.config.locale]
                    : undefined));
            tokenRegex.D = "(" + self.l10n.weekdays.shorthand.join("|") + ")";
            tokenRegex.l = "(" + self.l10n.weekdays.longhand.join("|") + ")";
            tokenRegex.M = "(" + self.l10n.months.shorthand.join("|") + ")";
            tokenRegex.F = "(" + self.l10n.months.longhand.join("|") + ")";
            tokenRegex.K = "(" + self.l10n.amPM[0] + "|" + self.l10n.amPM[1] + "|" + self.l10n.amPM[0].toLowerCase() + "|" + self.l10n.amPM[1].toLowerCase() + ")";
            var userConfig = __assign(__assign({}, instanceConfig), JSON.parse(JSON.stringify(element.dataset || {})));
            if (userConfig.time_24hr === undefined &&
                flatpickr.defaultConfig.time_24hr === undefined) {
                self.config.time_24hr = self.l10n.time_24hr;
            }
            self.formatDate = createDateFormatter(self);
            self.parseDate = createDateParser({ config: self.config, l10n: self.l10n });
        }
        function positionCalendar(customPositionElement) {
            if (typeof self.config.position === "function") {
                return void self.config.position(self, customPositionElement);
            }
            if (self.calendarContainer === undefined)
                return;
            triggerEvent("onPreCalendarPosition");
            var positionElement = customPositionElement || self._positionElement;
            var calendarHeight = Array.prototype.reduce.call(self.calendarContainer.children, (function (acc, child) { return acc + child.offsetHeight; }), 0), calendarWidth = self.calendarContainer.offsetWidth, configPos = self.config.position.split(" "), configPosVertical = configPos[0], configPosHorizontal = configPos.length > 1 ? configPos[1] : null, inputBounds = positionElement.getBoundingClientRect(), distanceFromBottom = window.innerHeight - inputBounds.bottom, showOnTop = configPosVertical === "above" ||
                (configPosVertical !== "below" &&
                    distanceFromBottom < calendarHeight &&
                    inputBounds.top > calendarHeight);
            var top = window.pageYOffset +
                inputBounds.top +
                (!showOnTop ? positionElement.offsetHeight + 2 : -calendarHeight - 2);
            toggleClass(self.calendarContainer, "arrowTop", !showOnTop);
            toggleClass(self.calendarContainer, "arrowBottom", showOnTop);
            if (self.config.inline)
                return;
            var left = window.pageXOffset + inputBounds.left;
            var isCenter = false;
            var isRight = false;
            if (configPosHorizontal === "center") {
                left -= (calendarWidth - inputBounds.width) / 2;
                isCenter = true;
            }
            else if (configPosHorizontal === "right") {
                left -= calendarWidth - inputBounds.width;
                isRight = true;
            }
            toggleClass(self.calendarContainer, "arrowLeft", !isCenter && !isRight);
            toggleClass(self.calendarContainer, "arrowCenter", isCenter);
            toggleClass(self.calendarContainer, "arrowRight", isRight);
            var right = window.document.body.offsetWidth -
                (window.pageXOffset + inputBounds.right);
            var rightMost = left + calendarWidth > window.document.body.offsetWidth;
            var centerMost = right + calendarWidth > window.document.body.offsetWidth;
            toggleClass(self.calendarContainer, "rightMost", rightMost);
            if (self.config.static)
                return;
            self.calendarContainer.style.top = top + "px";
            if (!rightMost) {
                self.calendarContainer.style.left = left + "px";
                self.calendarContainer.style.right = "auto";
            }
            else if (!centerMost) {
                self.calendarContainer.style.left = "auto";
                self.calendarContainer.style.right = right + "px";
            }
            else {
                var doc = getDocumentStyleSheet();
                // some testing environments don't have css support
                if (doc === undefined)
                    return;
                var bodyWidth = window.document.body.offsetWidth;
                var centerLeft = Math.max(0, bodyWidth / 2 - calendarWidth / 2);
                var centerBefore = ".flatpickr-calendar.centerMost:before";
                var centerAfter = ".flatpickr-calendar.centerMost:after";
                var centerIndex = doc.cssRules.length;
                var centerStyle = "{left:" + inputBounds.left + "px;right:auto;}";
                toggleClass(self.calendarContainer, "rightMost", false);
                toggleClass(self.calendarContainer, "centerMost", true);
                doc.insertRule(centerBefore + "," + centerAfter + centerStyle, centerIndex);
                self.calendarContainer.style.left = centerLeft + "px";
                self.calendarContainer.style.right = "auto";
            }
        }
        function getDocumentStyleSheet() {
            var editableSheet = null;
            for (var i = 0; i < document.styleSheets.length; i++) {
                var sheet = document.styleSheets[i];
                if (!sheet.cssRules)
                    continue;
                try {
                    sheet.cssRules;
                }
                catch (err) {
                    continue;
                }
                editableSheet = sheet;
                break;
            }
            return editableSheet != null ? editableSheet : createStyleSheet();
        }
        function createStyleSheet() {
            var style = document.createElement("style");
            document.head.appendChild(style);
            return style.sheet;
        }
        function redraw() {
            if (self.config.noCalendar || self.isMobile)
                return;
            buildMonthSwitch();
            updateNavigationCurrentMonth();
            buildDays();
        }
        function focusAndClose() {
            self._input.focus();
            if (window.navigator.userAgent.indexOf("MSIE") !== -1 ||
                navigator.msMaxTouchPoints !== undefined) {
                // hack - bugs in the way IE handles focus keeps the calendar open
                setTimeout(self.close, 0);
            }
            else {
                self.close();
            }
        }
        function selectDate(e) {
            e.preventDefault();
            e.stopPropagation();
            var isSelectable = function (day) {
                return day.classList &&
                    day.classList.contains("flatpickr-day") &&
                    !day.classList.contains("flatpickr-disabled") &&
                    !day.classList.contains("notAllowed");
            };
            var t = findParent(getEventTarget(e), isSelectable);
            if (t === undefined)
                return;
            var target = t;
            var selectedDate = (self.latestSelectedDateObj = new Date(target.dateObj.getTime()));
            var shouldChangeMonth = (selectedDate.getMonth() < self.currentMonth ||
                selectedDate.getMonth() >
                    self.currentMonth + self.config.showMonths - 1) &&
                self.config.mode !== "range";
            self.selectedDateElem = target;
            if (self.config.mode === "single")
                self.selectedDates = [selectedDate];
            else if (self.config.mode === "multiple") {
                var selectedIndex = isDateSelected(selectedDate);
                if (selectedIndex)
                    self.selectedDates.splice(parseInt(selectedIndex), 1);
                else
                    self.selectedDates.push(selectedDate);
            }
            else if (self.config.mode === "range") {
                if (self.selectedDates.length === 2) {
                    self.clear(false, false);
                }
                self.latestSelectedDateObj = selectedDate;
                self.selectedDates.push(selectedDate);
                // unless selecting same date twice, sort ascendingly
                if (compareDates(selectedDate, self.selectedDates[0], true) !== 0)
                    self.selectedDates.sort(function (a, b) { return a.getTime() - b.getTime(); });
            }
            setHoursFromInputs();
            if (shouldChangeMonth) {
                var isNewYear = self.currentYear !== selectedDate.getFullYear();
                self.currentYear = selectedDate.getFullYear();
                self.currentMonth = selectedDate.getMonth();
                if (isNewYear) {
                    triggerEvent("onYearChange");
                    buildMonthSwitch();
                }
                triggerEvent("onMonthChange");
            }
            updateNavigationCurrentMonth();
            buildDays();
            updateValue();
            // maintain focus
            if (!shouldChangeMonth &&
                self.config.mode !== "range" &&
                self.config.showMonths === 1)
                focusOnDayElem(target);
            else if (self.selectedDateElem !== undefined &&
                self.hourElement === undefined) {
                self.selectedDateElem && self.selectedDateElem.focus();
            }
            if (self.hourElement !== undefined)
                self.hourElement !== undefined && self.hourElement.focus();
            if (self.config.closeOnSelect) {
                var single = self.config.mode === "single" && !self.config.enableTime;
                var range = self.config.mode === "range" &&
                    self.selectedDates.length === 2 &&
                    !self.config.enableTime;
                if (single || range) {
                    focusAndClose();
                }
            }
            triggerChange();
        }
        var CALLBACKS = {
            locale: [setupLocale, updateWeekdays],
            showMonths: [buildMonths, setCalendarWidth, buildWeekdays],
            minDate: [jumpToDate],
            maxDate: [jumpToDate],
            positionElement: [updatePositionElement],
            clickOpens: [
                function () {
                    if (self.config.clickOpens === true) {
                        bind(self._input, "focus", self.open);
                        bind(self._input, "click", self.open);
                    }
                    else {
                        self._input.removeEventListener("focus", self.open);
                        self._input.removeEventListener("click", self.open);
                    }
                },
            ],
        };
        function set(option, value) {
            if (option !== null && typeof option === "object") {
                Object.assign(self.config, option);
                for (var key in option) {
                    if (CALLBACKS[key] !== undefined)
                        CALLBACKS[key].forEach(function (x) { return x(); });
                }
            }
            else {
                self.config[option] = value;
                if (CALLBACKS[option] !== undefined)
                    CALLBACKS[option].forEach(function (x) { return x(); });
                else if (HOOKS.indexOf(option) > -1)
                    self.config[option] = arrayify(value);
            }
            self.redraw();
            updateValue(true);
        }
        function setSelectedDate(inputDate, format) {
            var dates = [];
            if (inputDate instanceof Array)
                dates = inputDate.map(function (d) { return self.parseDate(d, format); });
            else if (inputDate instanceof Date || typeof inputDate === "number")
                dates = [self.parseDate(inputDate, format)];
            else if (typeof inputDate === "string") {
                switch (self.config.mode) {
                    case "single":
                    case "time":
                        dates = [self.parseDate(inputDate, format)];
                        break;
                    case "multiple":
                        dates = inputDate
                            .split(self.config.conjunction)
                            .map(function (date) { return self.parseDate(date, format); });
                        break;
                    case "range":
                        dates = inputDate
                            .split(self.l10n.rangeSeparator)
                            .map(function (date) { return self.parseDate(date, format); });
                        break;
                }
            }
            else
                self.config.errorHandler(new Error("Invalid date supplied: " + JSON.stringify(inputDate)));
            self.selectedDates = (self.config.allowInvalidPreload
                ? dates
                : dates.filter(function (d) { return d instanceof Date && isEnabled(d, false); }));
            if (self.config.mode === "range")
                self.selectedDates.sort(function (a, b) { return a.getTime() - b.getTime(); });
        }
        function setDate(date, triggerChange, format) {
            if (triggerChange === void 0) { triggerChange = false; }
            if (format === void 0) { format = self.config.dateFormat; }
            if ((date !== 0 && !date) || (date instanceof Array && date.length === 0))
                return self.clear(triggerChange);
            setSelectedDate(date, format);
            self.latestSelectedDateObj =
                self.selectedDates[self.selectedDates.length - 1];
            self.redraw();
            jumpToDate(undefined, triggerChange);
            setHoursFromDate();
            if (self.selectedDates.length === 0) {
                self.clear(false);
            }
            updateValue(triggerChange);
            if (triggerChange)
                triggerEvent("onChange");
        }
        function parseDateRules(arr) {
            return arr
                .slice()
                .map(function (rule) {
                if (typeof rule === "string" ||
                    typeof rule === "number" ||
                    rule instanceof Date) {
                    return self.parseDate(rule, undefined, true);
                }
                else if (rule &&
                    typeof rule === "object" &&
                    rule.from &&
                    rule.to)
                    return {
                        from: self.parseDate(rule.from, undefined),
                        to: self.parseDate(rule.to, undefined),
                    };
                return rule;
            })
                .filter(function (x) { return x; }); // remove falsy values
        }
        function setupDates() {
            self.selectedDates = [];
            self.now = self.parseDate(self.config.now) || new Date();
            // Workaround IE11 setting placeholder as the input's value
            var preloadedDate = self.config.defaultDate ||
                ((self.input.nodeName === "INPUT" ||
                    self.input.nodeName === "TEXTAREA") &&
                    self.input.placeholder &&
                    self.input.value === self.input.placeholder
                    ? null
                    : self.input.value);
            if (preloadedDate)
                setSelectedDate(preloadedDate, self.config.dateFormat);
            self._initialDate =
                self.selectedDates.length > 0
                    ? self.selectedDates[0]
                    : self.config.minDate &&
                        self.config.minDate.getTime() > self.now.getTime()
                        ? self.config.minDate
                        : self.config.maxDate &&
                            self.config.maxDate.getTime() < self.now.getTime()
                            ? self.config.maxDate
                            : self.now;
            self.currentYear = self._initialDate.getFullYear();
            self.currentMonth = self._initialDate.getMonth();
            if (self.selectedDates.length > 0)
                self.latestSelectedDateObj = self.selectedDates[0];
            if (self.config.minTime !== undefined)
                self.config.minTime = self.parseDate(self.config.minTime, "H:i");
            if (self.config.maxTime !== undefined)
                self.config.maxTime = self.parseDate(self.config.maxTime, "H:i");
            self.minDateHasTime =
                !!self.config.minDate &&
                    (self.config.minDate.getHours() > 0 ||
                        self.config.minDate.getMinutes() > 0 ||
                        self.config.minDate.getSeconds() > 0);
            self.maxDateHasTime =
                !!self.config.maxDate &&
                    (self.config.maxDate.getHours() > 0 ||
                        self.config.maxDate.getMinutes() > 0 ||
                        self.config.maxDate.getSeconds() > 0);
        }
        function setupInputs() {
            self.input = getInputElem();
            /* istanbul ignore next */
            if (!self.input) {
                self.config.errorHandler(new Error("Invalid input element specified"));
                return;
            }
            // hack: store previous type to restore it after destroy()
            self.input._type = self.input.type;
            self.input.type = "text";
            self.input.classList.add("flatpickr-input");
            self._input = self.input;
            if (self.config.altInput) {
                // replicate self.element
                self.altInput = createElement(self.input.nodeName, self.config.altInputClass);
                self._input = self.altInput;
                self.altInput.placeholder = self.input.placeholder;
                self.altInput.disabled = self.input.disabled;
                self.altInput.required = self.input.required;
                self.altInput.tabIndex = self.input.tabIndex;
                self.altInput.type = "text";
                self.input.setAttribute("type", "hidden");
                if (!self.config.static && self.input.parentNode)
                    self.input.parentNode.insertBefore(self.altInput, self.input.nextSibling);
            }
            if (!self.config.allowInput)
                self._input.setAttribute("readonly", "readonly");
            updatePositionElement();
        }
        function updatePositionElement() {
            self._positionElement = self.config.positionElement || self._input;
        }
        function setupMobile() {
            var inputType = self.config.enableTime
                ? self.config.noCalendar
                    ? "time"
                    : "datetime-local"
                : "date";
            self.mobileInput = createElement("input", self.input.className + " flatpickr-mobile");
            self.mobileInput.tabIndex = 1;
            self.mobileInput.type = inputType;
            self.mobileInput.disabled = self.input.disabled;
            self.mobileInput.required = self.input.required;
            self.mobileInput.placeholder = self.input.placeholder;
            self.mobileFormatStr =
                inputType === "datetime-local"
                    ? "Y-m-d\\TH:i:S"
                    : inputType === "date"
                        ? "Y-m-d"
                        : "H:i:S";
            if (self.selectedDates.length > 0) {
                self.mobileInput.defaultValue = self.mobileInput.value = self.formatDate(self.selectedDates[0], self.mobileFormatStr);
            }
            if (self.config.minDate)
                self.mobileInput.min = self.formatDate(self.config.minDate, "Y-m-d");
            if (self.config.maxDate)
                self.mobileInput.max = self.formatDate(self.config.maxDate, "Y-m-d");
            if (self.input.getAttribute("step"))
                self.mobileInput.step = String(self.input.getAttribute("step"));
            self.input.type = "hidden";
            if (self.altInput !== undefined)
                self.altInput.type = "hidden";
            try {
                if (self.input.parentNode)
                    self.input.parentNode.insertBefore(self.mobileInput, self.input.nextSibling);
            }
            catch (_a) { }
            bind(self.mobileInput, "change", function (e) {
                self.setDate(getEventTarget(e).value, false, self.mobileFormatStr);
                triggerEvent("onChange");
                triggerEvent("onClose");
            });
        }
        function toggle(e) {
            if (self.isOpen === true)
                return self.close();
            self.open(e);
        }
        function triggerEvent(event, data) {
            // If the instance has been destroyed already, all hooks have been removed
            if (self.config === undefined)
                return;
            var hooks = self.config[event];
            if (hooks !== undefined && hooks.length > 0) {
                for (var i = 0; hooks[i] && i < hooks.length; i++)
                    hooks[i](self.selectedDates, self.input.value, self, data);
            }
            if (event === "onChange") {
                self.input.dispatchEvent(createEvent("change"));
                // many front-end frameworks bind to the input event
                self.input.dispatchEvent(createEvent("input"));
            }
        }
        function createEvent(name) {
            var e = document.createEvent("Event");
            e.initEvent(name, true, true);
            return e;
        }
        function isDateSelected(date) {
            for (var i = 0; i < self.selectedDates.length; i++) {
                var selectedDate = self.selectedDates[i];
                if (selectedDate instanceof Date && compareDates(selectedDate, date) === 0)
                    return "" + i;
            }
            return false;
        }
        function isDateInRange(date) {
            if (self.config.mode !== "range" || self.selectedDates.length < 2)
                return false;
            return (compareDates(date, self.selectedDates[0]) >= 0 &&
                compareDates(date, self.selectedDates[1]) <= 0);
        }
        function updateNavigationCurrentMonth() {
            if (self.config.noCalendar || self.isMobile || !self.monthNav)
                return;
            self.yearElements.forEach(function (yearElement, i) {
                var d = new Date(self.currentYear, self.currentMonth, 1);
                d.setMonth(self.currentMonth + i);
                if (self.config.showMonths > 1 ||
                    self.config.monthSelectorType === "static") {
                    self.monthElements[i].textContent =
                        monthToStr(d.getMonth(), self.config.shorthandCurrentMonth, self.l10n) + " ";
                }
                else {
                    self.monthsDropdownContainer.value = d.getMonth().toString();
                }
                yearElement.value = d.getFullYear().toString();
            });
            self._hidePrevMonthArrow =
                self.config.minDate !== undefined &&
                    (self.currentYear === self.config.minDate.getFullYear()
                        ? self.currentMonth <= self.config.minDate.getMonth()
                        : self.currentYear < self.config.minDate.getFullYear());
            self._hideNextMonthArrow =
                self.config.maxDate !== undefined &&
                    (self.currentYear === self.config.maxDate.getFullYear()
                        ? self.currentMonth + 1 > self.config.maxDate.getMonth()
                        : self.currentYear > self.config.maxDate.getFullYear());
        }
        function getDateStr(format) {
            return self.selectedDates
                .map(function (dObj) { return self.formatDate(dObj, format); })
                .filter(function (d, i, arr) {
                return self.config.mode !== "range" ||
                    self.config.enableTime ||
                    arr.indexOf(d) === i;
            })
                .join(self.config.mode !== "range"
                ? self.config.conjunction
                : self.l10n.rangeSeparator);
        }
        /**
         * Updates the values of inputs associated with the calendar
         */
        function updateValue(triggerChange) {
            if (triggerChange === void 0) { triggerChange = true; }
            if (self.mobileInput !== undefined && self.mobileFormatStr) {
                self.mobileInput.value =
                    self.latestSelectedDateObj !== undefined
                        ? self.formatDate(self.latestSelectedDateObj, self.mobileFormatStr)
                        : "";
            }
            self.input.value = getDateStr(self.config.dateFormat);
            if (self.altInput !== undefined) {
                self.altInput.value = getDateStr(self.config.altFormat);
            }
            if (triggerChange !== false)
                triggerEvent("onValueUpdate");
        }
        function onMonthNavClick(e) {
            var eventTarget = getEventTarget(e);
            var isPrevMonth = self.prevMonthNav.contains(eventTarget);
            var isNextMonth = self.nextMonthNav.contains(eventTarget);
            if (isPrevMonth || isNextMonth) {
                changeMonth(isPrevMonth ? -1 : 1);
            }
            else if (self.yearElements.indexOf(eventTarget) >= 0) {
                eventTarget.select();
            }
            else if (eventTarget.classList.contains("arrowUp")) {
                self.changeYear(self.currentYear + 1);
            }
            else if (eventTarget.classList.contains("arrowDown")) {
                self.changeYear(self.currentYear - 1);
            }
        }
        function timeWrapper(e) {
            e.preventDefault();
            var isKeyDown = e.type === "keydown", eventTarget = getEventTarget(e), input = eventTarget;
            if (self.amPM !== undefined && eventTarget === self.amPM) {
                self.amPM.textContent =
                    self.l10n.amPM[int(self.amPM.textContent === self.l10n.amPM[0])];
            }
            var min = parseFloat(input.getAttribute("min")), max = parseFloat(input.getAttribute("max")), step = parseFloat(input.getAttribute("step")), curValue = parseInt(input.value, 10), delta = e.delta ||
                (isKeyDown ? (e.which === 38 ? 1 : -1) : 0);
            var newValue = curValue + step * delta;
            if (typeof input.value !== "undefined" && input.value.length === 2) {
                var isHourElem = input === self.hourElement, isMinuteElem = input === self.minuteElement;
                if (newValue < min) {
                    newValue =
                        max +
                            newValue +
                            int(!isHourElem) +
                            (int(isHourElem) && int(!self.amPM));
                    if (isMinuteElem)
                        incrementNumInput(undefined, -1, self.hourElement);
                }
                else if (newValue > max) {
                    newValue =
                        input === self.hourElement ? newValue - max - int(!self.amPM) : min;
                    if (isMinuteElem)
                        incrementNumInput(undefined, 1, self.hourElement);
                }
                if (self.amPM &&
                    isHourElem &&
                    (step === 1
                        ? newValue + curValue === 23
                        : Math.abs(newValue - curValue) > step)) {
                    self.amPM.textContent =
                        self.l10n.amPM[int(self.amPM.textContent === self.l10n.amPM[0])];
                }
                input.value = pad(newValue);
            }
        }
        init();
        return self;
    }
    /* istanbul ignore next */
    function _flatpickr(nodeList, config) {
        // static list
        var nodes = Array.prototype.slice
            .call(nodeList)
            .filter(function (x) { return x instanceof HTMLElement; });
        var instances = [];
        for (var i = 0; i < nodes.length; i++) {
            var node = nodes[i];
            try {
                if (node.getAttribute("data-fp-omit") !== null)
                    continue;
                if (node._flatpickr !== undefined) {
                    node._flatpickr.destroy();
                    node._flatpickr = undefined;
                }
                node._flatpickr = FlatpickrInstance(node, config || {});
                instances.push(node._flatpickr);
            }
            catch (e) {
                console.error(e);
            }
        }
        return instances.length === 1 ? instances[0] : instances;
    }
    /* istanbul ignore next */
    if (typeof HTMLElement !== "undefined" &&
        typeof HTMLCollection !== "undefined" &&
        typeof NodeList !== "undefined") {
        // browser env
        HTMLCollection.prototype.flatpickr = NodeList.prototype.flatpickr = function (config) {
            return _flatpickr(this, config);
        };
        HTMLElement.prototype.flatpickr = function (config) {
            return _flatpickr([this], config);
        };
    }
    /* istanbul ignore next */
    var flatpickr = function (selector, config) {
        if (typeof selector === "string") {
            return _flatpickr(window.document.querySelectorAll(selector), config);
        }
        else if (selector instanceof Node) {
            return _flatpickr([selector], config);
        }
        else {
            return _flatpickr(selector, config);
        }
    };
    /* istanbul ignore next */
    flatpickr.defaultConfig = {};
    flatpickr.l10ns = {
        en: __assign({}, english),
        default: __assign({}, english),
    };
    flatpickr.localize = function (l10n) {
        flatpickr.l10ns.default = __assign(__assign({}, flatpickr.l10ns.default), l10n);
    };
    flatpickr.setDefaults = function (config) {
        flatpickr.defaultConfig = __assign(__assign({}, flatpickr.defaultConfig), config);
    };
    flatpickr.parseDate = createDateParser({});
    flatpickr.formatDate = createDateFormatter({});
    flatpickr.compareDates = compareDates;
    /* istanbul ignore next */
    if (typeof jQuery !== "undefined" && typeof jQuery.fn !== "undefined") {
        jQuery.fn.flatpickr = function (config) {
            return _flatpickr(this, config);
        };
    }
    Date.prototype.fp_incr = function (days) {
        return new Date(this.getFullYear(), this.getMonth(), this.getDate() + (typeof days === "string" ? parseInt(days, 10) : days));
    };
    if (typeof window !== "undefined") {
        window.flatpickr = flatpickr;
    }

    return flatpickr;

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global['ar-dz'] = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var AlgerianArabic = {
      weekdays: {
          shorthand: ["أحد", "اثنين", "ثلاثاء", "أربعاء", "خميس", "جمعة", "سبت"],
          longhand: [
              "الأحد",
              "الاثنين",
              "الثلاثاء",
              "الأربعاء",
              "الخميس",
              "الجمعة",
              "السبت",
          ],
      },
      months: {
          shorthand: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
          longhand: [
              "جانفي",
              "فيفري",
              "مارس",
              "أفريل",
              "ماي",
              "جوان",
              "جويليه",
              "أوت",
              "سبتمبر",
              "أكتوبر",
              "نوفمبر",
              "ديسمبر",
          ],
      },
      firstDayOfWeek: 0,
      rangeSeparator: " إلى ",
      weekAbbreviation: "Wk",
      scrollTitle: "قم بالتمرير للزيادة",
      toggleTitle: "اضغط للتبديل",
      yearAriaLabel: "سنة",
      monthAriaLabel: "شهر",
      hourAriaLabel: "ساعة",
      minuteAriaLabel: "دقيقة",
      time_24hr: true,
  };
  fp.l10ns.ar = AlgerianArabic;
  var arDz = fp.l10ns;

  exports.AlgerianArabic = AlgerianArabic;
  exports.default = arDz;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ar = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Arabic = {
      weekdays: {
          shorthand: ["أحد", "اثنين", "ثلاثاء", "أربعاء", "خميس", "جمعة", "سبت"],
          longhand: [
              "الأحد",
              "الاثنين",
              "الثلاثاء",
              "الأربعاء",
              "الخميس",
              "الجمعة",
              "السبت",
          ],
      },
      months: {
          shorthand: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
          longhand: [
              "يناير",
              "فبراير",
              "مارس",
              "أبريل",
              "مايو",
              "يونيو",
              "يوليو",
              "أغسطس",
              "سبتمبر",
              "أكتوبر",
              "نوفمبر",
              "ديسمبر",
          ],
      },
      firstDayOfWeek: 6,
      rangeSeparator: " إلى ",
      weekAbbreviation: "Wk",
      scrollTitle: "قم بالتمرير للزيادة",
      toggleTitle: "اضغط للتبديل",
      amPM: ["ص", "م"],
      yearAriaLabel: "سنة",
      monthAriaLabel: "شهر",
      hourAriaLabel: "ساعة",
      minuteAriaLabel: "دقيقة",
      time_24hr: false,
  };
  fp.l10ns.ar = Arabic;
  var ar = fp.l10ns;

  exports.Arabic = Arabic;
  exports.default = ar;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.at = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Austria = {
      weekdays: {
          shorthand: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
          longhand: [
              "Sonntag",
              "Montag",
              "Dienstag",
              "Mittwoch",
              "Donnerstag",
              "Freitag",
              "Samstag",
          ],
      },
      months: {
          shorthand: [
              "Jän",
              "Feb",
              "Mär",
              "Apr",
              "Mai",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Dez",
          ],
          longhand: [
              "Jänner",
              "Februar",
              "März",
              "April",
              "Mai",
              "Juni",
              "Juli",
              "August",
              "September",
              "Oktober",
              "November",
              "Dezember",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "KW",
      rangeSeparator: " bis ",
      scrollTitle: "Zum Ändern scrollen",
      toggleTitle: "Zum Umschalten klicken",
      time_24hr: true,
  };
  fp.l10ns.at = Austria;
  var at = fp.l10ns;

  exports.Austria = Austria;
  exports.default = at;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.az = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Azerbaijan = {
      weekdays: {
          shorthand: ["B.", "B.e.", "Ç.a.", "Ç.", "C.a.", "C.", "Ş."],
          longhand: [
              "Bazar",
              "Bazar ertəsi",
              "Çərşənbə axşamı",
              "Çərşənbə",
              "Cümə axşamı",
              "Cümə",
              "Şənbə",
          ],
      },
      months: {
          shorthand: [
              "Yan",
              "Fev",
              "Mar",
              "Apr",
              "May",
              "İyn",
              "İyl",
              "Avq",
              "Sen",
              "Okt",
              "Noy",
              "Dek",
          ],
          longhand: [
              "Yanvar",
              "Fevral",
              "Mart",
              "Aprel",
              "May",
              "İyun",
              "İyul",
              "Avqust",
              "Sentyabr",
              "Oktyabr",
              "Noyabr",
              "Dekabr",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return ".";
      },
      rangeSeparator: " - ",
      weekAbbreviation: "Hf",
      scrollTitle: "Artırmaq üçün sürüşdürün",
      toggleTitle: "Aç / Bağla",
      amPM: ["GƏ", "GS"],
      time_24hr: true,
  };
  fp.l10ns.az = Azerbaijan;
  var az = fp.l10ns;

  exports.Azerbaijan = Azerbaijan;
  exports.default = az;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.be = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Belarusian = {
      weekdays: {
          shorthand: ["Нд", "Пн", "Аў", "Ср", "Чц", "Пт", "Сб"],
          longhand: [
              "Нядзеля",
              "Панядзелак",
              "Аўторак",
              "Серада",
              "Чацвер",
              "Пятніца",
              "Субота",
          ],
      },
      months: {
          shorthand: [
              "Сту",
              "Лют",
              "Сак",
              "Кра",
              "Тра",
              "Чэр",
              "Ліп",
              "Жні",
              "Вер",
              "Кас",
              "Ліс",
              "Сне",
          ],
          longhand: [
              "Студзень",
              "Люты",
              "Сакавік",
              "Красавік",
              "Травень",
              "Чэрвень",
              "Ліпень",
              "Жнівень",
              "Верасень",
              "Кастрычнік",
              "Лістапад",
              "Снежань",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "Тыд.",
      scrollTitle: "Пракруціце для павелічэння",
      toggleTitle: "Націсніце для пераключэння",
      amPM: ["ДП", "ПП"],
      yearAriaLabel: "Год",
      time_24hr: true,
  };
  fp.l10ns.be = Belarusian;
  var be = fp.l10ns;

  exports.Belarusian = Belarusian;
  exports.default = be;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.bg = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Bulgarian = {
      weekdays: {
          shorthand: ["Нд", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
          longhand: [
              "Неделя",
              "Понеделник",
              "Вторник",
              "Сряда",
              "Четвъртък",
              "Петък",
              "Събота",
          ],
      },
      months: {
          shorthand: [
              "Яну",
              "Фев",
              "Март",
              "Апр",
              "Май",
              "Юни",
              "Юли",
              "Авг",
              "Сеп",
              "Окт",
              "Ное",
              "Дек",
          ],
          longhand: [
              "Януари",
              "Февруари",
              "Март",
              "Април",
              "Май",
              "Юни",
              "Юли",
              "Август",
              "Септември",
              "Октомври",
              "Ноември",
              "Декември",
          ],
      },
      time_24hr: true,
      firstDayOfWeek: 1,
  };
  fp.l10ns.bg = Bulgarian;
  var bg = fp.l10ns;

  exports.Bulgarian = Bulgarian;
  exports.default = bg;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.bn = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Bangla = {
      weekdays: {
          shorthand: ["রবি", "সোম", "মঙ্গল", "বুধ", "বৃহস্পতি", "শুক্র", "শনি"],
          longhand: [
              "রবিবার",
              "সোমবার",
              "মঙ্গলবার",
              "বুধবার",
              "বৃহস্পতিবার",
              "শুক্রবার",
              "শনিবার",
          ],
      },
      months: {
          shorthand: [
              "জানু",
              "ফেব্রু",
              "মার্চ",
              "এপ্রিল",
              "মে",
              "জুন",
              "জুলাই",
              "আগ",
              "সেপ্টে",
              "অক্টো",
              "নভে",
              "ডিসে",
          ],
          longhand: [
              "জানুয়ারী",
              "ফেব্রুয়ারী",
              "মার্চ",
              "এপ্রিল",
              "মে",
              "জুন",
              "জুলাই",
              "আগস্ট",
              "সেপ্টেম্বর",
              "অক্টোবর",
              "নভেম্বর",
              "ডিসেম্বর",
          ],
      },
  };
  fp.l10ns.bn = Bangla;
  var bn = fp.l10ns;

  exports.Bangla = Bangla;
  exports.default = bn;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.bs = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Bosnian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"],
          longhand: [
              "Nedjelja",
              "Ponedjeljak",
              "Utorak",
              "Srijeda",
              "Četvrtak",
              "Petak",
              "Subota",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Maj",
              "Jun",
              "Jul",
              "Avg",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Januar",
              "Februar",
              "Mart",
              "April",
              "Maj",
              "Juni",
              "Juli",
              "Avgust",
              "Septembar",
              "Oktobar",
              "Novembar",
              "Decembar",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.bs = Bosnian;
  var bs = fp.l10ns;

  exports.Bosnian = Bosnian;
  exports.default = bs;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.cat = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Catalan = {
      weekdays: {
          shorthand: ["Dg", "Dl", "Dt", "Dc", "Dj", "Dv", "Ds"],
          longhand: [
              "Diumenge",
              "Dilluns",
              "Dimarts",
              "Dimecres",
              "Dijous",
              "Divendres",
              "Dissabte",
          ],
      },
      months: {
          shorthand: [
              "Gen",
              "Febr",
              "Març",
              "Abr",
              "Maig",
              "Juny",
              "Jul",
              "Ag",
              "Set",
              "Oct",
              "Nov",
              "Des",
          ],
          longhand: [
              "Gener",
              "Febrer",
              "Març",
              "Abril",
              "Maig",
              "Juny",
              "Juliol",
              "Agost",
              "Setembre",
              "Octubre",
              "Novembre",
              "Desembre",
          ],
      },
      ordinal: function (nth) {
          var s = nth % 100;
          if (s > 3 && s < 21)
              return "è";
          switch (s % 10) {
              case 1:
                  return "r";
              case 2:
                  return "n";
              case 3:
                  return "r";
              case 4:
                  return "t";
              default:
                  return "è";
          }
      },
      firstDayOfWeek: 1,
      rangeSeparator: " a ",
      time_24hr: true,
  };
  fp.l10ns.cat = fp.l10ns.ca = Catalan;
  var cat = fp.l10ns;

  exports.Catalan = Catalan;
  exports.default = cat;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ckb = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Kurdish = {
      weekdays: {
          shorthand: ["یەکشەممە", "دووشەممە", "سێشەممە", "چوارشەممە", "پێنجشەممە", "هەینی", "شەممە"],
          longhand: [
              "یەکشەممە",
              "دووشەممە",
              "سێشەممە",
              "چوارشەممە",
              "پێنجشەممە",
              "هەینی",
              "شەممە",
          ],
      },
      months: {
          shorthand: [
              "ڕێبەندان",
              "ڕەشەمە",
              "نەورۆز",
              "گوڵان",
              "جۆزەردان",
              "پووشپەڕ",
              "گەلاوێژ",
              "خەرمانان",
              "ڕەزبەر",
              "گەڵاڕێزان",
              "سەرماوەز",
              "بەفرانبار",
          ],
          longhand: [
              "ڕێبەندان",
              "ڕەشەمە",
              "نەورۆز",
              "گوڵان",
              "جۆزەردان",
              "پووشپەڕ",
              "گەلاوێژ",
              "خەرمانان",
              "ڕەزبەر",
              "گەڵاڕێزان",
              "سەرماوەز",
              "بەفرانبار",
          ],
      },
      firstDayOfWeek: 6,
      ordinal: function () {
          return "";
      },
  };
  fp.l10ns.ckb = Kurdish;
  var ckb = fp.l10ns;

  exports.Kurdish = Kurdish;
  exports.default = ckb;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.cs = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Czech = {
      weekdays: {
          shorthand: ["Ne", "Po", "Út", "St", "Čt", "Pá", "So"],
          longhand: [
              "Neděle",
              "Pondělí",
              "Úterý",
              "Středa",
              "Čtvrtek",
              "Pátek",
              "Sobota",
          ],
      },
      months: {
          shorthand: [
              "Led",
              "Ún",
              "Bře",
              "Dub",
              "Kvě",
              "Čer",
              "Čvc",
              "Srp",
              "Zář",
              "Říj",
              "Lis",
              "Pro",
          ],
          longhand: [
              "Leden",
              "Únor",
              "Březen",
              "Duben",
              "Květen",
              "Červen",
              "Červenec",
              "Srpen",
              "Září",
              "Říjen",
              "Listopad",
              "Prosinec",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return ".";
      },
      rangeSeparator: " do ",
      weekAbbreviation: "Týd.",
      scrollTitle: "Rolujte pro změnu",
      toggleTitle: "Přepnout dopoledne/odpoledne",
      amPM: ["dop.", "odp."],
      yearAriaLabel: "Rok",
      time_24hr: true,
  };
  fp.l10ns.cs = Czech;
  var cs = fp.l10ns;

  exports.Czech = Czech;
  exports.default = cs;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.cy = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Welsh = {
      weekdays: {
          shorthand: ["Sul", "Llun", "Maw", "Mer", "Iau", "Gwe", "Sad"],
          longhand: [
              "Dydd Sul",
              "Dydd Llun",
              "Dydd Mawrth",
              "Dydd Mercher",
              "Dydd Iau",
              "Dydd Gwener",
              "Dydd Sadwrn",
          ],
      },
      months: {
          shorthand: [
              "Ion",
              "Chwef",
              "Maw",
              "Ebr",
              "Mai",
              "Meh",
              "Gorff",
              "Awst",
              "Medi",
              "Hyd",
              "Tach",
              "Rhag",
          ],
          longhand: [
              "Ionawr",
              "Chwefror",
              "Mawrth",
              "Ebrill",
              "Mai",
              "Mehefin",
              "Gorffennaf",
              "Awst",
              "Medi",
              "Hydref",
              "Tachwedd",
              "Rhagfyr",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function (nth) {
          if (nth === 1)
              return "af";
          if (nth === 2)
              return "ail";
          if (nth === 3 || nth === 4)
              return "ydd";
          if (nth === 5 || nth === 6)
              return "ed";
          if ((nth >= 7 && nth <= 10) ||
              nth == 12 ||
              nth == 15 ||
              nth == 18 ||
              nth == 20)
              return "fed";
          if (nth == 11 ||
              nth == 13 ||
              nth == 14 ||
              nth == 16 ||
              nth == 17 ||
              nth == 19)
              return "eg";
          if (nth >= 21 && nth <= 39)
              return "ain";
          // Inconclusive.
          return "";
      },
      time_24hr: true,
  };
  fp.l10ns.cy = Welsh;
  var cy = fp.l10ns;

  exports.Welsh = Welsh;
  exports.default = cy;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.da = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Danish = {
      weekdays: {
          shorthand: ["søn", "man", "tir", "ons", "tors", "fre", "lør"],
          longhand: [
              "søndag",
              "mandag",
              "tirsdag",
              "onsdag",
              "torsdag",
              "fredag",
              "lørdag",
          ],
      },
      months: {
          shorthand: [
              "jan",
              "feb",
              "mar",
              "apr",
              "maj",
              "jun",
              "jul",
              "aug",
              "sep",
              "okt",
              "nov",
              "dec",
          ],
          longhand: [
              "januar",
              "februar",
              "marts",
              "april",
              "maj",
              "juni",
              "juli",
              "august",
              "september",
              "oktober",
              "november",
              "december",
          ],
      },
      ordinal: function () {
          return ".";
      },
      firstDayOfWeek: 1,
      rangeSeparator: " til ",
      weekAbbreviation: "uge",
      time_24hr: true,
  };
  fp.l10ns.da = Danish;
  var da = fp.l10ns;

  exports.Danish = Danish;
  exports.default = da;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.de = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var German = {
      weekdays: {
          shorthand: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
          longhand: [
              "Sonntag",
              "Montag",
              "Dienstag",
              "Mittwoch",
              "Donnerstag",
              "Freitag",
              "Samstag",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mär",
              "Apr",
              "Mai",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Dez",
          ],
          longhand: [
              "Januar",
              "Februar",
              "März",
              "April",
              "Mai",
              "Juni",
              "Juli",
              "August",
              "September",
              "Oktober",
              "November",
              "Dezember",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "KW",
      rangeSeparator: " bis ",
      scrollTitle: "Zum Ändern scrollen",
      toggleTitle: "Zum Umschalten klicken",
      time_24hr: true,
  };
  fp.l10ns.de = German;
  var de = fp.l10ns;

  exports.German = German;
  exports.default = de;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.default = {}));
}(this, (function (exports) { 'use strict';

  var english = {
      weekdays: {
          shorthand: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
          longhand: [
              "Sunday",
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec",
          ],
          longhand: [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December",
          ],
      },
      daysInMonth: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
      firstDayOfWeek: 0,
      ordinal: function (nth) {
          var s = nth % 100;
          if (s > 3 && s < 21)
              return "th";
          switch (s % 10) {
              case 1:
                  return "st";
              case 2:
                  return "nd";
              case 3:
                  return "rd";
              default:
                  return "th";
          }
      },
      rangeSeparator: " to ",
      weekAbbreviation: "Wk",
      scrollTitle: "Scroll to increment",
      toggleTitle: "Click to toggle",
      amPM: ["AM", "PM"],
      yearAriaLabel: "Year",
      monthAriaLabel: "Month",
      hourAriaLabel: "Hour",
      minuteAriaLabel: "Minute",
      time_24hr: false,
  };

  exports.default = english;
  exports.english = english;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.eo = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Esperanto = {
      firstDayOfWeek: 1,
      rangeSeparator: " ĝis ",
      weekAbbreviation: "Sem",
      scrollTitle: "Rulumu por pligrandigi la valoron",
      toggleTitle: "Klaku por ŝalti",
      weekdays: {
          shorthand: ["Dim", "Lun", "Mar", "Mer", "Ĵaŭ", "Ven", "Sab"],
          longhand: [
              "dimanĉo",
              "lundo",
              "mardo",
              "merkredo",
              "ĵaŭdo",
              "vendredo",
              "sabato",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Maj",
              "Jun",
              "Jul",
              "Aŭg",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "januaro",
              "februaro",
              "marto",
              "aprilo",
              "majo",
              "junio",
              "julio",
              "aŭgusto",
              "septembro",
              "oktobro",
              "novembro",
              "decembro",
          ],
      },
      ordinal: function () {
          return "-a";
      },
      time_24hr: true,
  };
  fp.l10ns.eo = Esperanto;
  var eo = fp.l10ns;

  exports.Esperanto = Esperanto;
  exports.default = eo;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.es = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Spanish = {
      weekdays: {
          shorthand: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"],
          longhand: [
              "Domingo",
              "Lunes",
              "Martes",
              "Miércoles",
              "Jueves",
              "Viernes",
              "Sábado",
          ],
      },
      months: {
          shorthand: [
              "Ene",
              "Feb",
              "Mar",
              "Abr",
              "May",
              "Jun",
              "Jul",
              "Ago",
              "Sep",
              "Oct",
              "Nov",
              "Dic",
          ],
          longhand: [
              "Enero",
              "Febrero",
              "Marzo",
              "Abril",
              "Mayo",
              "Junio",
              "Julio",
              "Agosto",
              "Septiembre",
              "Octubre",
              "Noviembre",
              "Diciembre",
          ],
      },
      ordinal: function () {
          return "º";
      },
      firstDayOfWeek: 1,
      rangeSeparator: " a ",
      time_24hr: true,
  };
  fp.l10ns.es = Spanish;
  var es = fp.l10ns;

  exports.Spanish = Spanish;
  exports.default = es;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.et = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Estonian = {
      weekdays: {
          shorthand: ["P", "E", "T", "K", "N", "R", "L"],
          longhand: [
              "Pühapäev",
              "Esmaspäev",
              "Teisipäev",
              "Kolmapäev",
              "Neljapäev",
              "Reede",
              "Laupäev",
          ],
      },
      months: {
          shorthand: [
              "Jaan",
              "Veebr",
              "Märts",
              "Apr",
              "Mai",
              "Juuni",
              "Juuli",
              "Aug",
              "Sept",
              "Okt",
              "Nov",
              "Dets",
          ],
          longhand: [
              "Jaanuar",
              "Veebruar",
              "Märts",
              "Aprill",
              "Mai",
              "Juuni",
              "Juuli",
              "August",
              "September",
              "Oktoober",
              "November",
              "Detsember",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return ".";
      },
      weekAbbreviation: "Näd",
      rangeSeparator: " kuni ",
      scrollTitle: "Keri, et suurendada",
      toggleTitle: "Klõpsa, et vahetada",
      time_24hr: true,
  };
  fp.l10ns.et = Estonian;
  var et = fp.l10ns;

  exports.Estonian = Estonian;
  exports.default = et;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.fa = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Persian = {
      weekdays: {
          shorthand: ["یک", "دو", "سه", "چهار", "پنج", "جمعه", "شنبه"],
          longhand: [
              "یک‌شنبه",
              "دوشنبه",
              "سه‌شنبه",
              "چهارشنبه",
              "پنچ‌شنبه",
              "جمعه",
              "شنبه",
          ],
      },
      months: {
          shorthand: [
              "ژانویه",
              "فوریه",
              "مارس",
              "آوریل",
              "مه",
              "ژوئن",
              "ژوئیه",
              "اوت",
              "سپتامبر",
              "اکتبر",
              "نوامبر",
              "دسامبر",
          ],
          longhand: [
              "ژانویه",
              "فوریه",
              "مارس",
              "آوریل",
              "مه",
              "ژوئن",
              "ژوئیه",
              "اوت",
              "سپتامبر",
              "اکتبر",
              "نوامبر",
              "دسامبر",
          ],
      },
      firstDayOfWeek: 6,
      ordinal: function () {
          return "";
      },
  };
  fp.l10ns.fa = Persian;
  var fa = fp.l10ns;

  exports.Persian = Persian;
  exports.default = fa;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.fi = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Finnish = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["su", "ma", "ti", "ke", "to", "pe", "la"],
          longhand: [
              "sunnuntai",
              "maanantai",
              "tiistai",
              "keskiviikko",
              "torstai",
              "perjantai",
              "lauantai",
          ],
      },
      months: {
          shorthand: [
              "tammi",
              "helmi",
              "maalis",
              "huhti",
              "touko",
              "kesä",
              "heinä",
              "elo",
              "syys",
              "loka",
              "marras",
              "joulu",
          ],
          longhand: [
              "tammikuu",
              "helmikuu",
              "maaliskuu",
              "huhtikuu",
              "toukokuu",
              "kesäkuu",
              "heinäkuu",
              "elokuu",
              "syyskuu",
              "lokakuu",
              "marraskuu",
              "joulukuu",
          ],
      },
      ordinal: function () {
          return ".";
      },
      time_24hr: true,
  };
  fp.l10ns.fi = Finnish;
  var fi = fp.l10ns;

  exports.Finnish = Finnish;
  exports.default = fi;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.fo = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Faroese = {
      weekdays: {
          shorthand: ["Sun", "Mán", "Týs", "Mik", "Hós", "Frí", "Ley"],
          longhand: [
              "Sunnudagur",
              "Mánadagur",
              "Týsdagur",
              "Mikudagur",
              "Hósdagur",
              "Fríggjadagur",
              "Leygardagur",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Mai",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Des",
          ],
          longhand: [
              "Januar",
              "Februar",
              "Mars",
              "Apríl",
              "Mai",
              "Juni",
              "Juli",
              "August",
              "Septembur",
              "Oktobur",
              "Novembur",
              "Desembur",
          ],
      },
      ordinal: function () {
          return ".";
      },
      firstDayOfWeek: 1,
      rangeSeparator: " til ",
      weekAbbreviation: "vika",
      scrollTitle: "Rulla fyri at broyta",
      toggleTitle: "Trýst fyri at skifta",
      yearAriaLabel: "Ár",
      time_24hr: true,
  };
  fp.l10ns.fo = Faroese;
  var fo = fp.l10ns;

  exports.Faroese = Faroese;
  exports.default = fo;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.fr = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var French = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["dim", "lun", "mar", "mer", "jeu", "ven", "sam"],
          longhand: [
              "dimanche",
              "lundi",
              "mardi",
              "mercredi",
              "jeudi",
              "vendredi",
              "samedi",
          ],
      },
      months: {
          shorthand: [
              "janv",
              "févr",
              "mars",
              "avr",
              "mai",
              "juin",
              "juil",
              "août",
              "sept",
              "oct",
              "nov",
              "déc",
          ],
          longhand: [
              "janvier",
              "février",
              "mars",
              "avril",
              "mai",
              "juin",
              "juillet",
              "août",
              "septembre",
              "octobre",
              "novembre",
              "décembre",
          ],
      },
      ordinal: function (nth) {
          if (nth > 1)
              return "";
          return "er";
      },
      rangeSeparator: " au ",
      weekAbbreviation: "Sem",
      scrollTitle: "Défiler pour augmenter la valeur",
      toggleTitle: "Cliquer pour basculer",
      time_24hr: true,
  };
  fp.l10ns.fr = French;
  var fr = fp.l10ns;

  exports.French = French;
  exports.default = fr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ga = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Irish = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Dom", "Lua", "Mái", "Céa", "Déa", "Aoi", "Sat"],
          longhand: [
              "Dé Domhnaigh",
              "Dé Luain",
              "Dé Máirt",
              "Dé Céadaoin",
              "Déardaoin",
              "Dé hAoine",
              "Dé Sathairn",
          ],
      },
      months: {
          shorthand: [
              "Ean",
              "Fea",
              "Már",
              "Aib",
              "Bea",
              "Mei",
              "Iúi",
              "Lún",
              "MFo",
              "DFo",
              "Sam",
              "Nol",
          ],
          longhand: [
              "Eanáir",
              "Feabhra",
              "Márta",
              "Aibreán",
              "Bealtaine",
              "Meitheamh",
              "Iúil",
              "Lúnasa",
              "Meán Fómhair",
              "Deireadh Fómhair",
              "Samhain",
              "Nollaig",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.hr = Irish;
  var ga = fp.l10ns;

  exports.Irish = Irish;
  exports.default = ga;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.gr = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Greek = {
      weekdays: {
          shorthand: ["Κυ", "Δε", "Τρ", "Τε", "Πέ", "Πα", "Σά"],
          longhand: [
              "Κυριακή",
              "Δευτέρα",
              "Τρίτη",
              "Τετάρτη",
              "Πέμπτη",
              "Παρασκευή",
              "Σάββατο",
          ],
      },
      months: {
          shorthand: [
              "Ιαν",
              "Φεβ",
              "Μάρ",
              "Απρ",
              "Μάι",
              "Ιούν",
              "Ιούλ",
              "Αύγ",
              "Σεπ",
              "Οκτ",
              "Νοέ",
              "Δεκ",
          ],
          longhand: [
              "Ιανουάριος",
              "Φεβρουάριος",
              "Μάρτιος",
              "Απρίλιος",
              "Μάιος",
              "Ιούνιος",
              "Ιούλιος",
              "Αύγουστος",
              "Σεπτέμβριος",
              "Οκτώβριος",
              "Νοέμβριος",
              "Δεκέμβριος",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      weekAbbreviation: "Εβδ",
      rangeSeparator: " έως ",
      scrollTitle: "Μετακυλήστε για προσαύξηση",
      toggleTitle: "Κάντε κλικ για αλλαγή",
      amPM: ["ΠΜ", "ΜΜ"],
      yearAriaLabel: "χρόνος",
      monthAriaLabel: "μήνας",
      hourAriaLabel: "ώρα",
      minuteAriaLabel: "λεπτό",
  };
  fp.l10ns.gr = Greek;
  var gr = fp.l10ns;

  exports.Greek = Greek;
  exports.default = gr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.he = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Hebrew = {
      weekdays: {
          shorthand: ["א", "ב", "ג", "ד", "ה", "ו", "ש"],
          longhand: ["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"],
      },
      months: {
          shorthand: [
              "ינו׳",
              "פבר׳",
              "מרץ",
              "אפר׳",
              "מאי",
              "יוני",
              "יולי",
              "אוג׳",
              "ספט׳",
              "אוק׳",
              "נוב׳",
              "דצמ׳",
          ],
          longhand: [
              "ינואר",
              "פברואר",
              "מרץ",
              "אפריל",
              "מאי",
              "יוני",
              "יולי",
              "אוגוסט",
              "ספטמבר",
              "אוקטובר",
              "נובמבר",
              "דצמבר",
          ],
      },
      rangeSeparator: " אל ",
      time_24hr: true,
  };
  fp.l10ns.he = Hebrew;
  var he = fp.l10ns;

  exports.Hebrew = Hebrew;
  exports.default = he;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.hi = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Hindi = {
      weekdays: {
          shorthand: ["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"],
          longhand: [
              "रविवार",
              "सोमवार",
              "मंगलवार",
              "बुधवार",
              "गुरुवार",
              "शुक्रवार",
              "शनिवार",
          ],
      },
      months: {
          shorthand: [
              "जन",
              "फर",
              "मार्च",
              "अप्रेल",
              "मई",
              "जून",
              "जूलाई",
              "अग",
              "सित",
              "अक्ट",
              "नव",
              "दि",
          ],
          longhand: [
              "जनवरी ",
              "फरवरी",
              "मार्च",
              "अप्रेल",
              "मई",
              "जून",
              "जूलाई",
              "अगस्त ",
              "सितम्बर",
              "अक्टूबर",
              "नवम्बर",
              "दिसम्बर",
          ],
      },
  };
  fp.l10ns.hi = Hindi;
  var hi = fp.l10ns;

  exports.Hindi = Hindi;
  exports.default = hi;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.hr = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Croatian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"],
          longhand: [
              "Nedjelja",
              "Ponedjeljak",
              "Utorak",
              "Srijeda",
              "Četvrtak",
              "Petak",
              "Subota",
          ],
      },
      months: {
          shorthand: [
              "Sij",
              "Velj",
              "Ožu",
              "Tra",
              "Svi",
              "Lip",
              "Srp",
              "Kol",
              "Ruj",
              "Lis",
              "Stu",
              "Pro",
          ],
          longhand: [
              "Siječanj",
              "Veljača",
              "Ožujak",
              "Travanj",
              "Svibanj",
              "Lipanj",
              "Srpanj",
              "Kolovoz",
              "Rujan",
              "Listopad",
              "Studeni",
              "Prosinac",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.hr = Croatian;
  var hr = fp.l10ns;

  exports.Croatian = Croatian;
  exports.default = hr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.hu = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Hungarian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["V", "H", "K", "Sz", "Cs", "P", "Szo"],
          longhand: [
              "Vasárnap",
              "Hétfő",
              "Kedd",
              "Szerda",
              "Csütörtök",
              "Péntek",
              "Szombat",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Már",
              "Ápr",
              "Máj",
              "Jún",
              "Júl",
              "Aug",
              "Szep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Január",
              "Február",
              "Március",
              "Április",
              "Május",
              "Június",
              "Július",
              "Augusztus",
              "Szeptember",
              "Október",
              "November",
              "December",
          ],
      },
      ordinal: function () {
          return ".";
      },
      weekAbbreviation: "Hét",
      scrollTitle: "Görgessen",
      toggleTitle: "Kattintson a váltáshoz",
      rangeSeparator: " - ",
      time_24hr: true,
  };
  fp.l10ns.hu = Hungarian;
  var hu = fp.l10ns;

  exports.Hungarian = Hungarian;
  exports.default = hu;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.hy = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Armenian = {
      weekdays: {
          shorthand: [
              "Կիր",
              "Երկ",
              "Երք",
              "Չրք",
              "Հնգ",
              "Ուրբ",
              "Շբթ",
          ],
          longhand: [
              "Կիրակի",
              "Եկուշաբթի",
              "Երեքշաբթի",
              "Չորեքշաբթի",
              "Հինգշաբթի",
              "Ուրբաթ",
              "Շաբաթ",
          ],
      },
      months: {
          shorthand: [
              "Հնվ",
              "Փտր",
              "Մար",
              "Ապր",
              "Մայ",
              "Հնս",
              "Հլս",
              "Օգս",
              "Սեպ",
              "Հոկ",
              "Նմբ",
              "Դեկ",
          ],
          longhand: [
              "Հունվար",
              "Փետրվար",
              "Մարտ",
              "Ապրիլ",
              "Մայիս",
              "Հունիս",
              "Հուլիս",
              "Օգոստոս",
              "Սեպտեմբեր",
              "Հոկտեմբեր",
              "Նոյեմբեր",
              "Դեկտեմբեր",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "ՇԲՏ",
      scrollTitle: "Ոլորեք՝ մեծացնելու համար",
      toggleTitle: "Սեղմեք՝ փոխելու համար",
      amPM: ["ՄԿ", "ԿՀ"],
      yearAriaLabel: "Տարի",
      monthAriaLabel: "Ամիս",
      hourAriaLabel: "Ժամ",
      minuteAriaLabel: "Րոպե",
      time_24hr: true,
  };
  fp.l10ns.hy = Armenian;
  var hy = fp.l10ns;

  exports.Armenian = Armenian;
  exports.default = hy;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.id = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Indonesian = {
      weekdays: {
          shorthand: ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"],
          longhand: ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Mei",
              "Jun",
              "Jul",
              "Agu",
              "Sep",
              "Okt",
              "Nov",
              "Des",
          ],
          longhand: [
              "Januari",
              "Februari",
              "Maret",
              "April",
              "Mei",
              "Juni",
              "Juli",
              "Agustus",
              "September",
              "Oktober",
              "November",
              "Desember",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      time_24hr: true,
      rangeSeparator: " - ",
  };
  fp.l10ns.id = Indonesian;
  var id = fp.l10ns;

  exports.Indonesian = Indonesian;
  exports.default = id;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
    typeof define === 'function' && define.amd ? define(['exports'], factory) :
    (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.index = {}));
}(this, (function (exports) { 'use strict';

    /*! *****************************************************************************
    Copyright (c) Microsoft Corporation.

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
    OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
    ***************************************************************************** */

    var __assign = function() {
        __assign = Object.assign || function __assign(t) {
            for (var s, i = 1, n = arguments.length; i < n; i++) {
                s = arguments[i];
                for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
            }
            return t;
        };
        return __assign.apply(this, arguments);
    };

    var fp = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Arabic = {
        weekdays: {
            shorthand: ["أحد", "اثنين", "ثلاثاء", "أربعاء", "خميس", "جمعة", "سبت"],
            longhand: [
                "الأحد",
                "الاثنين",
                "الثلاثاء",
                "الأربعاء",
                "الخميس",
                "الجمعة",
                "السبت",
            ],
        },
        months: {
            shorthand: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            longhand: [
                "يناير",
                "فبراير",
                "مارس",
                "أبريل",
                "مايو",
                "يونيو",
                "يوليو",
                "أغسطس",
                "سبتمبر",
                "أكتوبر",
                "نوفمبر",
                "ديسمبر",
            ],
        },
        firstDayOfWeek: 6,
        rangeSeparator: " إلى ",
        weekAbbreviation: "Wk",
        scrollTitle: "قم بالتمرير للزيادة",
        toggleTitle: "اضغط للتبديل",
        amPM: ["ص", "م"],
        yearAriaLabel: "سنة",
        monthAriaLabel: "شهر",
        hourAriaLabel: "ساعة",
        minuteAriaLabel: "دقيقة",
        time_24hr: false,
    };
    fp.l10ns.ar = Arabic;
    fp.l10ns;

    var fp$1 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Austria = {
        weekdays: {
            shorthand: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
            longhand: [
                "Sonntag",
                "Montag",
                "Dienstag",
                "Mittwoch",
                "Donnerstag",
                "Freitag",
                "Samstag",
            ],
        },
        months: {
            shorthand: [
                "Jän",
                "Feb",
                "Mär",
                "Apr",
                "Mai",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Dez",
            ],
            longhand: [
                "Jänner",
                "Februar",
                "März",
                "April",
                "Mai",
                "Juni",
                "Juli",
                "August",
                "September",
                "Oktober",
                "November",
                "Dezember",
            ],
        },
        firstDayOfWeek: 1,
        weekAbbreviation: "KW",
        rangeSeparator: " bis ",
        scrollTitle: "Zum Ändern scrollen",
        toggleTitle: "Zum Umschalten klicken",
        time_24hr: true,
    };
    fp$1.l10ns.at = Austria;
    fp$1.l10ns;

    var fp$2 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Azerbaijan = {
        weekdays: {
            shorthand: ["B.", "B.e.", "Ç.a.", "Ç.", "C.a.", "C.", "Ş."],
            longhand: [
                "Bazar",
                "Bazar ertəsi",
                "Çərşənbə axşamı",
                "Çərşənbə",
                "Cümə axşamı",
                "Cümə",
                "Şənbə",
            ],
        },
        months: {
            shorthand: [
                "Yan",
                "Fev",
                "Mar",
                "Apr",
                "May",
                "İyn",
                "İyl",
                "Avq",
                "Sen",
                "Okt",
                "Noy",
                "Dek",
            ],
            longhand: [
                "Yanvar",
                "Fevral",
                "Mart",
                "Aprel",
                "May",
                "İyun",
                "İyul",
                "Avqust",
                "Sentyabr",
                "Oktyabr",
                "Noyabr",
                "Dekabr",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return ".";
        },
        rangeSeparator: " - ",
        weekAbbreviation: "Hf",
        scrollTitle: "Artırmaq üçün sürüşdürün",
        toggleTitle: "Aç / Bağla",
        amPM: ["GƏ", "GS"],
        time_24hr: true,
    };
    fp$2.l10ns.az = Azerbaijan;
    fp$2.l10ns;

    var fp$3 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Belarusian = {
        weekdays: {
            shorthand: ["Нд", "Пн", "Аў", "Ср", "Чц", "Пт", "Сб"],
            longhand: [
                "Нядзеля",
                "Панядзелак",
                "Аўторак",
                "Серада",
                "Чацвер",
                "Пятніца",
                "Субота",
            ],
        },
        months: {
            shorthand: [
                "Сту",
                "Лют",
                "Сак",
                "Кра",
                "Тра",
                "Чэр",
                "Ліп",
                "Жні",
                "Вер",
                "Кас",
                "Ліс",
                "Сне",
            ],
            longhand: [
                "Студзень",
                "Люты",
                "Сакавік",
                "Красавік",
                "Травень",
                "Чэрвень",
                "Ліпень",
                "Жнівень",
                "Верасень",
                "Кастрычнік",
                "Лістапад",
                "Снежань",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "Тыд.",
        scrollTitle: "Пракруціце для павелічэння",
        toggleTitle: "Націсніце для пераключэння",
        amPM: ["ДП", "ПП"],
        yearAriaLabel: "Год",
        time_24hr: true,
    };
    fp$3.l10ns.be = Belarusian;
    fp$3.l10ns;

    var fp$4 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Bosnian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"],
            longhand: [
                "Nedjelja",
                "Ponedjeljak",
                "Utorak",
                "Srijeda",
                "Četvrtak",
                "Petak",
                "Subota",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Maj",
                "Jun",
                "Jul",
                "Avg",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Januar",
                "Februar",
                "Mart",
                "April",
                "Maj",
                "Juni",
                "Juli",
                "Avgust",
                "Septembar",
                "Oktobar",
                "Novembar",
                "Decembar",
            ],
        },
        time_24hr: true,
    };
    fp$4.l10ns.bs = Bosnian;
    fp$4.l10ns;

    var fp$5 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Bulgarian = {
        weekdays: {
            shorthand: ["Нд", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
            longhand: [
                "Неделя",
                "Понеделник",
                "Вторник",
                "Сряда",
                "Четвъртък",
                "Петък",
                "Събота",
            ],
        },
        months: {
            shorthand: [
                "Яну",
                "Фев",
                "Март",
                "Апр",
                "Май",
                "Юни",
                "Юли",
                "Авг",
                "Сеп",
                "Окт",
                "Ное",
                "Дек",
            ],
            longhand: [
                "Януари",
                "Февруари",
                "Март",
                "Април",
                "Май",
                "Юни",
                "Юли",
                "Август",
                "Септември",
                "Октомври",
                "Ноември",
                "Декември",
            ],
        },
        time_24hr: true,
        firstDayOfWeek: 1,
    };
    fp$5.l10ns.bg = Bulgarian;
    fp$5.l10ns;

    var fp$6 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Bangla = {
        weekdays: {
            shorthand: ["রবি", "সোম", "মঙ্গল", "বুধ", "বৃহস্পতি", "শুক্র", "শনি"],
            longhand: [
                "রবিবার",
                "সোমবার",
                "মঙ্গলবার",
                "বুধবার",
                "বৃহস্পতিবার",
                "শুক্রবার",
                "শনিবার",
            ],
        },
        months: {
            shorthand: [
                "জানু",
                "ফেব্রু",
                "মার্চ",
                "এপ্রিল",
                "মে",
                "জুন",
                "জুলাই",
                "আগ",
                "সেপ্টে",
                "অক্টো",
                "নভে",
                "ডিসে",
            ],
            longhand: [
                "জানুয়ারী",
                "ফেব্রুয়ারী",
                "মার্চ",
                "এপ্রিল",
                "মে",
                "জুন",
                "জুলাই",
                "আগস্ট",
                "সেপ্টেম্বর",
                "অক্টোবর",
                "নভেম্বর",
                "ডিসেম্বর",
            ],
        },
    };
    fp$6.l10ns.bn = Bangla;
    fp$6.l10ns;

    var fp$7 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Catalan = {
        weekdays: {
            shorthand: ["Dg", "Dl", "Dt", "Dc", "Dj", "Dv", "Ds"],
            longhand: [
                "Diumenge",
                "Dilluns",
                "Dimarts",
                "Dimecres",
                "Dijous",
                "Divendres",
                "Dissabte",
            ],
        },
        months: {
            shorthand: [
                "Gen",
                "Febr",
                "Març",
                "Abr",
                "Maig",
                "Juny",
                "Jul",
                "Ag",
                "Set",
                "Oct",
                "Nov",
                "Des",
            ],
            longhand: [
                "Gener",
                "Febrer",
                "Març",
                "Abril",
                "Maig",
                "Juny",
                "Juliol",
                "Agost",
                "Setembre",
                "Octubre",
                "Novembre",
                "Desembre",
            ],
        },
        ordinal: function (nth) {
            var s = nth % 100;
            if (s > 3 && s < 21)
                return "è";
            switch (s % 10) {
                case 1:
                    return "r";
                case 2:
                    return "n";
                case 3:
                    return "r";
                case 4:
                    return "t";
                default:
                    return "è";
            }
        },
        firstDayOfWeek: 1,
        rangeSeparator: " a ",
        time_24hr: true,
    };
    fp$7.l10ns.cat = fp$7.l10ns.ca = Catalan;
    fp$7.l10ns;

    var fp$8 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Kurdish = {
        weekdays: {
            shorthand: ["یەکشەممە", "دووشەممە", "سێشەممە", "چوارشەممە", "پێنجشەممە", "هەینی", "شەممە"],
            longhand: [
                "یەکشەممە",
                "دووشەممە",
                "سێشەممە",
                "چوارشەممە",
                "پێنجشەممە",
                "هەینی",
                "شەممە",
            ],
        },
        months: {
            shorthand: [
                "ڕێبەندان",
                "ڕەشەمە",
                "نەورۆز",
                "گوڵان",
                "جۆزەردان",
                "پووشپەڕ",
                "گەلاوێژ",
                "خەرمانان",
                "ڕەزبەر",
                "گەڵاڕێزان",
                "سەرماوەز",
                "بەفرانبار",
            ],
            longhand: [
                "ڕێبەندان",
                "ڕەشەمە",
                "نەورۆز",
                "گوڵان",
                "جۆزەردان",
                "پووشپەڕ",
                "گەلاوێژ",
                "خەرمانان",
                "ڕەزبەر",
                "گەڵاڕێزان",
                "سەرماوەز",
                "بەفرانبار",
            ],
        },
        firstDayOfWeek: 6,
        ordinal: function () {
            return "";
        },
    };
    fp$8.l10ns.ckb = Kurdish;
    fp$8.l10ns;

    var fp$9 = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Czech = {
        weekdays: {
            shorthand: ["Ne", "Po", "Út", "St", "Čt", "Pá", "So"],
            longhand: [
                "Neděle",
                "Pondělí",
                "Úterý",
                "Středa",
                "Čtvrtek",
                "Pátek",
                "Sobota",
            ],
        },
        months: {
            shorthand: [
                "Led",
                "Ún",
                "Bře",
                "Dub",
                "Kvě",
                "Čer",
                "Čvc",
                "Srp",
                "Zář",
                "Říj",
                "Lis",
                "Pro",
            ],
            longhand: [
                "Leden",
                "Únor",
                "Březen",
                "Duben",
                "Květen",
                "Červen",
                "Červenec",
                "Srpen",
                "Září",
                "Říjen",
                "Listopad",
                "Prosinec",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return ".";
        },
        rangeSeparator: " do ",
        weekAbbreviation: "Týd.",
        scrollTitle: "Rolujte pro změnu",
        toggleTitle: "Přepnout dopoledne/odpoledne",
        amPM: ["dop.", "odp."],
        yearAriaLabel: "Rok",
        time_24hr: true,
    };
    fp$9.l10ns.cs = Czech;
    fp$9.l10ns;

    var fp$a = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Welsh = {
        weekdays: {
            shorthand: ["Sul", "Llun", "Maw", "Mer", "Iau", "Gwe", "Sad"],
            longhand: [
                "Dydd Sul",
                "Dydd Llun",
                "Dydd Mawrth",
                "Dydd Mercher",
                "Dydd Iau",
                "Dydd Gwener",
                "Dydd Sadwrn",
            ],
        },
        months: {
            shorthand: [
                "Ion",
                "Chwef",
                "Maw",
                "Ebr",
                "Mai",
                "Meh",
                "Gorff",
                "Awst",
                "Medi",
                "Hyd",
                "Tach",
                "Rhag",
            ],
            longhand: [
                "Ionawr",
                "Chwefror",
                "Mawrth",
                "Ebrill",
                "Mai",
                "Mehefin",
                "Gorffennaf",
                "Awst",
                "Medi",
                "Hydref",
                "Tachwedd",
                "Rhagfyr",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function (nth) {
            if (nth === 1)
                return "af";
            if (nth === 2)
                return "ail";
            if (nth === 3 || nth === 4)
                return "ydd";
            if (nth === 5 || nth === 6)
                return "ed";
            if ((nth >= 7 && nth <= 10) ||
                nth == 12 ||
                nth == 15 ||
                nth == 18 ||
                nth == 20)
                return "fed";
            if (nth == 11 ||
                nth == 13 ||
                nth == 14 ||
                nth == 16 ||
                nth == 17 ||
                nth == 19)
                return "eg";
            if (nth >= 21 && nth <= 39)
                return "ain";
            // Inconclusive.
            return "";
        },
        time_24hr: true,
    };
    fp$a.l10ns.cy = Welsh;
    fp$a.l10ns;

    var fp$b = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Danish = {
        weekdays: {
            shorthand: ["søn", "man", "tir", "ons", "tors", "fre", "lør"],
            longhand: [
                "søndag",
                "mandag",
                "tirsdag",
                "onsdag",
                "torsdag",
                "fredag",
                "lørdag",
            ],
        },
        months: {
            shorthand: [
                "jan",
                "feb",
                "mar",
                "apr",
                "maj",
                "jun",
                "jul",
                "aug",
                "sep",
                "okt",
                "nov",
                "dec",
            ],
            longhand: [
                "januar",
                "februar",
                "marts",
                "april",
                "maj",
                "juni",
                "juli",
                "august",
                "september",
                "oktober",
                "november",
                "december",
            ],
        },
        ordinal: function () {
            return ".";
        },
        firstDayOfWeek: 1,
        rangeSeparator: " til ",
        weekAbbreviation: "uge",
        time_24hr: true,
    };
    fp$b.l10ns.da = Danish;
    fp$b.l10ns;

    var fp$c = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var German = {
        weekdays: {
            shorthand: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
            longhand: [
                "Sonntag",
                "Montag",
                "Dienstag",
                "Mittwoch",
                "Donnerstag",
                "Freitag",
                "Samstag",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mär",
                "Apr",
                "Mai",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Dez",
            ],
            longhand: [
                "Januar",
                "Februar",
                "März",
                "April",
                "Mai",
                "Juni",
                "Juli",
                "August",
                "September",
                "Oktober",
                "November",
                "Dezember",
            ],
        },
        firstDayOfWeek: 1,
        weekAbbreviation: "KW",
        rangeSeparator: " bis ",
        scrollTitle: "Zum Ändern scrollen",
        toggleTitle: "Zum Umschalten klicken",
        time_24hr: true,
    };
    fp$c.l10ns.de = German;
    fp$c.l10ns;

    var english = {
        weekdays: {
            shorthand: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            longhand: [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec",
            ],
            longhand: [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
            ],
        },
        daysInMonth: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        firstDayOfWeek: 0,
        ordinal: function (nth) {
            var s = nth % 100;
            if (s > 3 && s < 21)
                return "th";
            switch (s % 10) {
                case 1:
                    return "st";
                case 2:
                    return "nd";
                case 3:
                    return "rd";
                default:
                    return "th";
            }
        },
        rangeSeparator: " to ",
        weekAbbreviation: "Wk",
        scrollTitle: "Scroll to increment",
        toggleTitle: "Click to toggle",
        amPM: ["AM", "PM"],
        yearAriaLabel: "Year",
        monthAriaLabel: "Month",
        hourAriaLabel: "Hour",
        minuteAriaLabel: "Minute",
        time_24hr: false,
    };

    var fp$d = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Esperanto = {
        firstDayOfWeek: 1,
        rangeSeparator: " ĝis ",
        weekAbbreviation: "Sem",
        scrollTitle: "Rulumu por pligrandigi la valoron",
        toggleTitle: "Klaku por ŝalti",
        weekdays: {
            shorthand: ["Dim", "Lun", "Mar", "Mer", "Ĵaŭ", "Ven", "Sab"],
            longhand: [
                "dimanĉo",
                "lundo",
                "mardo",
                "merkredo",
                "ĵaŭdo",
                "vendredo",
                "sabato",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Maj",
                "Jun",
                "Jul",
                "Aŭg",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "januaro",
                "februaro",
                "marto",
                "aprilo",
                "majo",
                "junio",
                "julio",
                "aŭgusto",
                "septembro",
                "oktobro",
                "novembro",
                "decembro",
            ],
        },
        ordinal: function () {
            return "-a";
        },
        time_24hr: true,
    };
    fp$d.l10ns.eo = Esperanto;
    fp$d.l10ns;

    var fp$e = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Spanish = {
        weekdays: {
            shorthand: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"],
            longhand: [
                "Domingo",
                "Lunes",
                "Martes",
                "Miércoles",
                "Jueves",
                "Viernes",
                "Sábado",
            ],
        },
        months: {
            shorthand: [
                "Ene",
                "Feb",
                "Mar",
                "Abr",
                "May",
                "Jun",
                "Jul",
                "Ago",
                "Sep",
                "Oct",
                "Nov",
                "Dic",
            ],
            longhand: [
                "Enero",
                "Febrero",
                "Marzo",
                "Abril",
                "Mayo",
                "Junio",
                "Julio",
                "Agosto",
                "Septiembre",
                "Octubre",
                "Noviembre",
                "Diciembre",
            ],
        },
        ordinal: function () {
            return "º";
        },
        firstDayOfWeek: 1,
        rangeSeparator: " a ",
        time_24hr: true,
    };
    fp$e.l10ns.es = Spanish;
    fp$e.l10ns;

    var fp$f = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Estonian = {
        weekdays: {
            shorthand: ["P", "E", "T", "K", "N", "R", "L"],
            longhand: [
                "Pühapäev",
                "Esmaspäev",
                "Teisipäev",
                "Kolmapäev",
                "Neljapäev",
                "Reede",
                "Laupäev",
            ],
        },
        months: {
            shorthand: [
                "Jaan",
                "Veebr",
                "Märts",
                "Apr",
                "Mai",
                "Juuni",
                "Juuli",
                "Aug",
                "Sept",
                "Okt",
                "Nov",
                "Dets",
            ],
            longhand: [
                "Jaanuar",
                "Veebruar",
                "Märts",
                "Aprill",
                "Mai",
                "Juuni",
                "Juuli",
                "August",
                "September",
                "Oktoober",
                "November",
                "Detsember",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return ".";
        },
        weekAbbreviation: "Näd",
        rangeSeparator: " kuni ",
        scrollTitle: "Keri, et suurendada",
        toggleTitle: "Klõpsa, et vahetada",
        time_24hr: true,
    };
    fp$f.l10ns.et = Estonian;
    fp$f.l10ns;

    var fp$g = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Persian = {
        weekdays: {
            shorthand: ["یک", "دو", "سه", "چهار", "پنج", "جمعه", "شنبه"],
            longhand: [
                "یک‌شنبه",
                "دوشنبه",
                "سه‌شنبه",
                "چهارشنبه",
                "پنچ‌شنبه",
                "جمعه",
                "شنبه",
            ],
        },
        months: {
            shorthand: [
                "ژانویه",
                "فوریه",
                "مارس",
                "آوریل",
                "مه",
                "ژوئن",
                "ژوئیه",
                "اوت",
                "سپتامبر",
                "اکتبر",
                "نوامبر",
                "دسامبر",
            ],
            longhand: [
                "ژانویه",
                "فوریه",
                "مارس",
                "آوریل",
                "مه",
                "ژوئن",
                "ژوئیه",
                "اوت",
                "سپتامبر",
                "اکتبر",
                "نوامبر",
                "دسامبر",
            ],
        },
        firstDayOfWeek: 6,
        ordinal: function () {
            return "";
        },
    };
    fp$g.l10ns.fa = Persian;
    fp$g.l10ns;

    var fp$h = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Finnish = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["su", "ma", "ti", "ke", "to", "pe", "la"],
            longhand: [
                "sunnuntai",
                "maanantai",
                "tiistai",
                "keskiviikko",
                "torstai",
                "perjantai",
                "lauantai",
            ],
        },
        months: {
            shorthand: [
                "tammi",
                "helmi",
                "maalis",
                "huhti",
                "touko",
                "kesä",
                "heinä",
                "elo",
                "syys",
                "loka",
                "marras",
                "joulu",
            ],
            longhand: [
                "tammikuu",
                "helmikuu",
                "maaliskuu",
                "huhtikuu",
                "toukokuu",
                "kesäkuu",
                "heinäkuu",
                "elokuu",
                "syyskuu",
                "lokakuu",
                "marraskuu",
                "joulukuu",
            ],
        },
        ordinal: function () {
            return ".";
        },
        time_24hr: true,
    };
    fp$h.l10ns.fi = Finnish;
    fp$h.l10ns;

    var fp$i = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Faroese = {
        weekdays: {
            shorthand: ["Sun", "Mán", "Týs", "Mik", "Hós", "Frí", "Ley"],
            longhand: [
                "Sunnudagur",
                "Mánadagur",
                "Týsdagur",
                "Mikudagur",
                "Hósdagur",
                "Fríggjadagur",
                "Leygardagur",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Mai",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Des",
            ],
            longhand: [
                "Januar",
                "Februar",
                "Mars",
                "Apríl",
                "Mai",
                "Juni",
                "Juli",
                "August",
                "Septembur",
                "Oktobur",
                "Novembur",
                "Desembur",
            ],
        },
        ordinal: function () {
            return ".";
        },
        firstDayOfWeek: 1,
        rangeSeparator: " til ",
        weekAbbreviation: "vika",
        scrollTitle: "Rulla fyri at broyta",
        toggleTitle: "Trýst fyri at skifta",
        yearAriaLabel: "Ár",
        time_24hr: true,
    };
    fp$i.l10ns.fo = Faroese;
    fp$i.l10ns;

    var fp$j = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var French = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["dim", "lun", "mar", "mer", "jeu", "ven", "sam"],
            longhand: [
                "dimanche",
                "lundi",
                "mardi",
                "mercredi",
                "jeudi",
                "vendredi",
                "samedi",
            ],
        },
        months: {
            shorthand: [
                "janv",
                "févr",
                "mars",
                "avr",
                "mai",
                "juin",
                "juil",
                "août",
                "sept",
                "oct",
                "nov",
                "déc",
            ],
            longhand: [
                "janvier",
                "février",
                "mars",
                "avril",
                "mai",
                "juin",
                "juillet",
                "août",
                "septembre",
                "octobre",
                "novembre",
                "décembre",
            ],
        },
        ordinal: function (nth) {
            if (nth > 1)
                return "";
            return "er";
        },
        rangeSeparator: " au ",
        weekAbbreviation: "Sem",
        scrollTitle: "Défiler pour augmenter la valeur",
        toggleTitle: "Cliquer pour basculer",
        time_24hr: true,
    };
    fp$j.l10ns.fr = French;
    fp$j.l10ns;

    var fp$k = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Greek = {
        weekdays: {
            shorthand: ["Κυ", "Δε", "Τρ", "Τε", "Πέ", "Πα", "Σά"],
            longhand: [
                "Κυριακή",
                "Δευτέρα",
                "Τρίτη",
                "Τετάρτη",
                "Πέμπτη",
                "Παρασκευή",
                "Σάββατο",
            ],
        },
        months: {
            shorthand: [
                "Ιαν",
                "Φεβ",
                "Μάρ",
                "Απρ",
                "Μάι",
                "Ιούν",
                "Ιούλ",
                "Αύγ",
                "Σεπ",
                "Οκτ",
                "Νοέ",
                "Δεκ",
            ],
            longhand: [
                "Ιανουάριος",
                "Φεβρουάριος",
                "Μάρτιος",
                "Απρίλιος",
                "Μάιος",
                "Ιούνιος",
                "Ιούλιος",
                "Αύγουστος",
                "Σεπτέμβριος",
                "Οκτώβριος",
                "Νοέμβριος",
                "Δεκέμβριος",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        weekAbbreviation: "Εβδ",
        rangeSeparator: " έως ",
        scrollTitle: "Μετακυλήστε για προσαύξηση",
        toggleTitle: "Κάντε κλικ για αλλαγή",
        amPM: ["ΠΜ", "ΜΜ"],
        yearAriaLabel: "χρόνος",
        monthAriaLabel: "μήνας",
        hourAriaLabel: "ώρα",
        minuteAriaLabel: "λεπτό",
    };
    fp$k.l10ns.gr = Greek;
    fp$k.l10ns;

    var fp$l = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Hebrew = {
        weekdays: {
            shorthand: ["א", "ב", "ג", "ד", "ה", "ו", "ש"],
            longhand: ["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"],
        },
        months: {
            shorthand: [
                "ינו׳",
                "פבר׳",
                "מרץ",
                "אפר׳",
                "מאי",
                "יוני",
                "יולי",
                "אוג׳",
                "ספט׳",
                "אוק׳",
                "נוב׳",
                "דצמ׳",
            ],
            longhand: [
                "ינואר",
                "פברואר",
                "מרץ",
                "אפריל",
                "מאי",
                "יוני",
                "יולי",
                "אוגוסט",
                "ספטמבר",
                "אוקטובר",
                "נובמבר",
                "דצמבר",
            ],
        },
        rangeSeparator: " אל ",
        time_24hr: true,
    };
    fp$l.l10ns.he = Hebrew;
    fp$l.l10ns;

    var fp$m = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Hindi = {
        weekdays: {
            shorthand: ["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"],
            longhand: [
                "रविवार",
                "सोमवार",
                "मंगलवार",
                "बुधवार",
                "गुरुवार",
                "शुक्रवार",
                "शनिवार",
            ],
        },
        months: {
            shorthand: [
                "जन",
                "फर",
                "मार्च",
                "अप्रेल",
                "मई",
                "जून",
                "जूलाई",
                "अग",
                "सित",
                "अक्ट",
                "नव",
                "दि",
            ],
            longhand: [
                "जनवरी ",
                "फरवरी",
                "मार्च",
                "अप्रेल",
                "मई",
                "जून",
                "जूलाई",
                "अगस्त ",
                "सितम्बर",
                "अक्टूबर",
                "नवम्बर",
                "दिसम्बर",
            ],
        },
    };
    fp$m.l10ns.hi = Hindi;
    fp$m.l10ns;

    var fp$n = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Croatian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["Ned", "Pon", "Uto", "Sri", "Čet", "Pet", "Sub"],
            longhand: [
                "Nedjelja",
                "Ponedjeljak",
                "Utorak",
                "Srijeda",
                "Četvrtak",
                "Petak",
                "Subota",
            ],
        },
        months: {
            shorthand: [
                "Sij",
                "Velj",
                "Ožu",
                "Tra",
                "Svi",
                "Lip",
                "Srp",
                "Kol",
                "Ruj",
                "Lis",
                "Stu",
                "Pro",
            ],
            longhand: [
                "Siječanj",
                "Veljača",
                "Ožujak",
                "Travanj",
                "Svibanj",
                "Lipanj",
                "Srpanj",
                "Kolovoz",
                "Rujan",
                "Listopad",
                "Studeni",
                "Prosinac",
            ],
        },
        time_24hr: true,
    };
    fp$n.l10ns.hr = Croatian;
    fp$n.l10ns;

    var fp$o = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Hungarian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["V", "H", "K", "Sz", "Cs", "P", "Szo"],
            longhand: [
                "Vasárnap",
                "Hétfő",
                "Kedd",
                "Szerda",
                "Csütörtök",
                "Péntek",
                "Szombat",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Már",
                "Ápr",
                "Máj",
                "Jún",
                "Júl",
                "Aug",
                "Szep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Január",
                "Február",
                "Március",
                "Április",
                "Május",
                "Június",
                "Július",
                "Augusztus",
                "Szeptember",
                "Október",
                "November",
                "December",
            ],
        },
        ordinal: function () {
            return ".";
        },
        weekAbbreviation: "Hét",
        scrollTitle: "Görgessen",
        toggleTitle: "Kattintson a váltáshoz",
        rangeSeparator: " - ",
        time_24hr: true,
    };
    fp$o.l10ns.hu = Hungarian;
    fp$o.l10ns;

    var fp$p = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Armenian = {
        weekdays: {
            shorthand: [
                "Կիր",
                "Երկ",
                "Երք",
                "Չրք",
                "Հնգ",
                "Ուրբ",
                "Շբթ",
            ],
            longhand: [
                "Կիրակի",
                "Եկուշաբթի",
                "Երեքշաբթի",
                "Չորեքշաբթի",
                "Հինգշաբթի",
                "Ուրբաթ",
                "Շաբաթ",
            ],
        },
        months: {
            shorthand: [
                "Հնվ",
                "Փտր",
                "Մար",
                "Ապր",
                "Մայ",
                "Հնս",
                "Հլս",
                "Օգս",
                "Սեպ",
                "Հոկ",
                "Նմբ",
                "Դեկ",
            ],
            longhand: [
                "Հունվար",
                "Փետրվար",
                "Մարտ",
                "Ապրիլ",
                "Մայիս",
                "Հունիս",
                "Հուլիս",
                "Օգոստոս",
                "Սեպտեմբեր",
                "Հոկտեմբեր",
                "Նոյեմբեր",
                "Դեկտեմբեր",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "ՇԲՏ",
        scrollTitle: "Ոլորեք՝ մեծացնելու համար",
        toggleTitle: "Սեղմեք՝ փոխելու համար",
        amPM: ["ՄԿ", "ԿՀ"],
        yearAriaLabel: "Տարի",
        monthAriaLabel: "Ամիս",
        hourAriaLabel: "Ժամ",
        minuteAriaLabel: "Րոպե",
        time_24hr: true,
    };
    fp$p.l10ns.hy = Armenian;
    fp$p.l10ns;

    var fp$q = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Indonesian = {
        weekdays: {
            shorthand: ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"],
            longhand: ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Mei",
                "Jun",
                "Jul",
                "Agu",
                "Sep",
                "Okt",
                "Nov",
                "Des",
            ],
            longhand: [
                "Januari",
                "Februari",
                "Maret",
                "April",
                "Mei",
                "Juni",
                "Juli",
                "Agustus",
                "September",
                "Oktober",
                "November",
                "Desember",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        time_24hr: true,
        rangeSeparator: " - ",
    };
    fp$q.l10ns.id = Indonesian;
    fp$q.l10ns;

    var fp$r = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Icelandic = {
        weekdays: {
            shorthand: ["Sun", "Mán", "Þri", "Mið", "Fim", "Fös", "Lau"],
            longhand: [
                "Sunnudagur",
                "Mánudagur",
                "Þriðjudagur",
                "Miðvikudagur",
                "Fimmtudagur",
                "Föstudagur",
                "Laugardagur",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Maí",
                "Jún",
                "Júl",
                "Ágú",
                "Sep",
                "Okt",
                "Nóv",
                "Des",
            ],
            longhand: [
                "Janúar",
                "Febrúar",
                "Mars",
                "Apríl",
                "Maí",
                "Júní",
                "Júlí",
                "Ágúst",
                "September",
                "Október",
                "Nóvember",
                "Desember",
            ],
        },
        ordinal: function () {
            return ".";
        },
        firstDayOfWeek: 1,
        rangeSeparator: " til ",
        weekAbbreviation: "vika",
        yearAriaLabel: "Ár",
        time_24hr: true,
    };
    fp$r.l10ns.is = Icelandic;
    fp$r.l10ns;

    var fp$s = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Italian = {
        weekdays: {
            shorthand: ["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"],
            longhand: [
                "Domenica",
                "Lunedì",
                "Martedì",
                "Mercoledì",
                "Giovedì",
                "Venerdì",
                "Sabato",
            ],
        },
        months: {
            shorthand: [
                "Gen",
                "Feb",
                "Mar",
                "Apr",
                "Mag",
                "Giu",
                "Lug",
                "Ago",
                "Set",
                "Ott",
                "Nov",
                "Dic",
            ],
            longhand: [
                "Gennaio",
                "Febbraio",
                "Marzo",
                "Aprile",
                "Maggio",
                "Giugno",
                "Luglio",
                "Agosto",
                "Settembre",
                "Ottobre",
                "Novembre",
                "Dicembre",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () { return "°"; },
        rangeSeparator: " al ",
        weekAbbreviation: "Se",
        scrollTitle: "Scrolla per aumentare",
        toggleTitle: "Clicca per cambiare",
        time_24hr: true,
    };
    fp$s.l10ns.it = Italian;
    fp$s.l10ns;

    var fp$t = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Japanese = {
        weekdays: {
            shorthand: ["日", "月", "火", "水", "木", "金", "土"],
            longhand: [
                "日曜日",
                "月曜日",
                "火曜日",
                "水曜日",
                "木曜日",
                "金曜日",
                "土曜日",
            ],
        },
        months: {
            shorthand: [
                "1月",
                "2月",
                "3月",
                "4月",
                "5月",
                "6月",
                "7月",
                "8月",
                "9月",
                "10月",
                "11月",
                "12月",
            ],
            longhand: [
                "1月",
                "2月",
                "3月",
                "4月",
                "5月",
                "6月",
                "7月",
                "8月",
                "9月",
                "10月",
                "11月",
                "12月",
            ],
        },
        time_24hr: true,
        rangeSeparator: " から ",
        monthAriaLabel: "月",
        amPM: ["午前", "午後"],
        yearAriaLabel: "年",
        hourAriaLabel: "時間",
        minuteAriaLabel: "分",
    };
    fp$t.l10ns.ja = Japanese;
    fp$t.l10ns;

    var fp$u = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Georgian = {
        weekdays: {
            shorthand: ["კვ", "ორ", "სა", "ოთ", "ხუ", "პა", "შა"],
            longhand: [
                "კვირა",
                "ორშაბათი",
                "სამშაბათი",
                "ოთხშაბათი",
                "ხუთშაბათი",
                "პარასკევი",
                "შაბათი",
            ],
        },
        months: {
            shorthand: [
                "იან",
                "თებ",
                "მარ",
                "აპრ",
                "მაი",
                "ივნ",
                "ივლ",
                "აგვ",
                "სექ",
                "ოქტ",
                "ნოე",
                "დეკ",
            ],
            longhand: [
                "იანვარი",
                "თებერვალი",
                "მარტი",
                "აპრილი",
                "მაისი",
                "ივნისი",
                "ივლისი",
                "აგვისტო",
                "სექტემბერი",
                "ოქტომბერი",
                "ნოემბერი",
                "დეკემბერი",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "კვ.",
        scrollTitle: "დასქროლეთ გასადიდებლად",
        toggleTitle: "დააკლიკეთ გადართვისთვის",
        amPM: ["AM", "PM"],
        yearAriaLabel: "წელი",
        time_24hr: true,
    };
    fp$u.l10ns.ka = Georgian;
    fp$u.l10ns;

    var fp$v = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Korean = {
        weekdays: {
            shorthand: ["일", "월", "화", "수", "목", "금", "토"],
            longhand: [
                "일요일",
                "월요일",
                "화요일",
                "수요일",
                "목요일",
                "금요일",
                "토요일",
            ],
        },
        months: {
            shorthand: [
                "1월",
                "2월",
                "3월",
                "4월",
                "5월",
                "6월",
                "7월",
                "8월",
                "9월",
                "10월",
                "11월",
                "12월",
            ],
            longhand: [
                "1월",
                "2월",
                "3월",
                "4월",
                "5월",
                "6월",
                "7월",
                "8월",
                "9월",
                "10월",
                "11월",
                "12월",
            ],
        },
        ordinal: function () {
            return "일";
        },
        rangeSeparator: " ~ ",
        amPM: ["오전", "오후"],
    };
    fp$v.l10ns.ko = Korean;
    fp$v.l10ns;

    var fp$w = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Khmer = {
        weekdays: {
            shorthand: ["អាទិត្យ", "ចន្ទ", "អង្គារ", "ពុធ", "ព្រហស.", "សុក្រ", "សៅរ៍"],
            longhand: [
                "អាទិត្យ",
                "ចន្ទ",
                "អង្គារ",
                "ពុធ",
                "ព្រហស្បតិ៍",
                "សុក្រ",
                "សៅរ៍",
            ],
        },
        months: {
            shorthand: [
                "មករា",
                "កុម្ភះ",
                "មីនា",
                "មេសា",
                "ឧសភា",
                "មិថុនា",
                "កក្កដា",
                "សីហា",
                "កញ្ញា",
                "តុលា",
                "វិច្ឆិកា",
                "ធ្នូ",
            ],
            longhand: [
                "មករា",
                "កុម្ភះ",
                "មីនា",
                "មេសា",
                "ឧសភា",
                "មិថុនា",
                "កក្កដា",
                "សីហា",
                "កញ្ញា",
                "តុលា",
                "វិច្ឆិកា",
                "ធ្នូ",
            ],
        },
        ordinal: function () {
            return "";
        },
        firstDayOfWeek: 1,
        rangeSeparator: " ដល់ ",
        weekAbbreviation: "សប្តាហ៍",
        scrollTitle: "រំកិលដើម្បីបង្កើន",
        toggleTitle: "ចុចដើម្បីផ្លាស់ប្ដូរ",
        yearAriaLabel: "ឆ្នាំ",
        time_24hr: true,
    };
    fp$w.l10ns.km = Khmer;
    fp$w.l10ns;

    var fp$x = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Kazakh = {
        weekdays: {
            shorthand: ["Жс", "Дс", "Сc", "Ср", "Бс", "Жм", "Сб"],
            longhand: [
                "Жексенбi",
                "Дүйсенбi",
                "Сейсенбi",
                "Сәрсенбi",
                "Бейсенбi",
                "Жұма",
                "Сенбi",
            ],
        },
        months: {
            shorthand: [
                "Қаң",
                "Ақп",
                "Нау",
                "Сәу",
                "Мам",
                "Мау",
                "Шiл",
                "Там",
                "Қыр",
                "Қаз",
                "Қар",
                "Жел",
            ],
            longhand: [
                "Қаңтар",
                "Ақпан",
                "Наурыз",
                "Сәуiр",
                "Мамыр",
                "Маусым",
                "Шiлде",
                "Тамыз",
                "Қыркүйек",
                "Қазан",
                "Қараша",
                "Желтоқсан",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "Апта",
        scrollTitle: "Үлкейту үшін айналдырыңыз",
        toggleTitle: "Ауыстыру үшін басыңыз",
        amPM: ["ТД", "ТК"],
        yearAriaLabel: "Жыл",
    };
    fp$x.l10ns.kz = Kazakh;
    fp$x.l10ns;

    var fp$y = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Lithuanian = {
        weekdays: {
            shorthand: ["S", "Pr", "A", "T", "K", "Pn", "Š"],
            longhand: [
                "Sekmadienis",
                "Pirmadienis",
                "Antradienis",
                "Trečiadienis",
                "Ketvirtadienis",
                "Penktadienis",
                "Šeštadienis",
            ],
        },
        months: {
            shorthand: [
                "Sau",
                "Vas",
                "Kov",
                "Bal",
                "Geg",
                "Bir",
                "Lie",
                "Rgp",
                "Rgs",
                "Spl",
                "Lap",
                "Grd",
            ],
            longhand: [
                "Sausis",
                "Vasaris",
                "Kovas",
                "Balandis",
                "Gegužė",
                "Birželis",
                "Liepa",
                "Rugpjūtis",
                "Rugsėjis",
                "Spalis",
                "Lapkritis",
                "Gruodis",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "-a";
        },
        rangeSeparator: " iki ",
        weekAbbreviation: "Sav",
        scrollTitle: "Keisti laiką pelės rateliu",
        toggleTitle: "Perjungti laiko formatą",
        time_24hr: true,
    };
    fp$y.l10ns.lt = Lithuanian;
    fp$y.l10ns;

    var fp$z = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Latvian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["Sv", "Pr", "Ot", "Tr", "Ce", "Pk", "Se"],
            longhand: [
                "Svētdiena",
                "Pirmdiena",
                "Otrdiena",
                "Trešdiena",
                "Ceturtdiena",
                "Piektdiena",
                "Sestdiena",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Mai",
                "Jūn",
                "Jūl",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Janvāris",
                "Februāris",
                "Marts",
                "Aprīlis",
                "Maijs",
                "Jūnijs",
                "Jūlijs",
                "Augusts",
                "Septembris",
                "Oktobris",
                "Novembris",
                "Decembris",
            ],
        },
        rangeSeparator: " līdz ",
        time_24hr: true,
    };
    fp$z.l10ns.lv = Latvian;
    fp$z.l10ns;

    var fp$A = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Macedonian = {
        weekdays: {
            shorthand: ["Не", "По", "Вт", "Ср", "Че", "Пе", "Са"],
            longhand: [
                "Недела",
                "Понеделник",
                "Вторник",
                "Среда",
                "Четврток",
                "Петок",
                "Сабота",
            ],
        },
        months: {
            shorthand: [
                "Јан",
                "Фев",
                "Мар",
                "Апр",
                "Мај",
                "Јун",
                "Јул",
                "Авг",
                "Сеп",
                "Окт",
                "Ное",
                "Дек",
            ],
            longhand: [
                "Јануари",
                "Февруари",
                "Март",
                "Април",
                "Мај",
                "Јуни",
                "Јули",
                "Август",
                "Септември",
                "Октомври",
                "Ноември",
                "Декември",
            ],
        },
        firstDayOfWeek: 1,
        weekAbbreviation: "Нед.",
        rangeSeparator: " до ",
        time_24hr: true,
    };
    fp$A.l10ns.mk = Macedonian;
    fp$A.l10ns;

    var fp$B = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Mongolian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["Да", "Мя", "Лх", "Пү", "Ба", "Бя", "Ня"],
            longhand: ["Даваа", "Мягмар", "Лхагва", "Пүрэв", "Баасан", "Бямба", "Ням"],
        },
        months: {
            shorthand: [
                "1-р сар",
                "2-р сар",
                "3-р сар",
                "4-р сар",
                "5-р сар",
                "6-р сар",
                "7-р сар",
                "8-р сар",
                "9-р сар",
                "10-р сар",
                "11-р сар",
                "12-р сар",
            ],
            longhand: [
                "Нэгдүгээр сар",
                "Хоёрдугаар сар",
                "Гуравдугаар сар",
                "Дөрөвдүгээр сар",
                "Тавдугаар сар",
                "Зургаадугаар сар",
                "Долдугаар сар",
                "Наймдугаар сар",
                "Есдүгээр сар",
                "Аравдугаар сар",
                "Арваннэгдүгээр сар",
                "Арванхоёрдугаар сар",
            ],
        },
        rangeSeparator: "-с ",
        time_24hr: true,
    };
    fp$B.l10ns.mn = Mongolian;
    fp$B.l10ns;

    var fp$C = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Malaysian = {
        weekdays: {
            shorthand: ["Aha", "Isn", "Sel", "Rab", "Kha", "Jum", "Sab"],
            longhand: [
                "Ahad",
                "Isnin",
                "Selasa",
                "Rabu",
                "Khamis",
                "Jumaat",
                "Sabtu",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mac",
                "Apr",
                "Mei",
                "Jun",
                "Jul",
                "Ogo",
                "Sep",
                "Okt",
                "Nov",
                "Dis",
            ],
            longhand: [
                "Januari",
                "Februari",
                "Mac",
                "April",
                "Mei",
                "Jun",
                "Julai",
                "Ogos",
                "September",
                "Oktober",
                "November",
                "Disember",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
    };
    fp$C.l10ns;

    var fp$D = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Burmese = {
        weekdays: {
            shorthand: ["နွေ", "လာ", "ဂါ", "ဟူး", "ကြာ", "သော", "နေ"],
            longhand: [
                "တနင်္ဂနွေ",
                "တနင်္လာ",
                "အင်္ဂါ",
                "ဗုဒ္ဓဟူး",
                "ကြာသပတေး",
                "သောကြာ",
                "စနေ",
            ],
        },
        months: {
            shorthand: [
                "ဇန်",
                "ဖေ",
                "မတ်",
                "ပြီ",
                "မေ",
                "ဇွန်",
                "လိုင်",
                "သြ",
                "စက်",
                "အောက်",
                "နို",
                "ဒီ",
            ],
            longhand: [
                "ဇန်နဝါရီ",
                "ဖေဖော်ဝါရီ",
                "မတ်",
                "ဧပြီ",
                "မေ",
                "ဇွန်",
                "ဇူလိုင်",
                "သြဂုတ်",
                "စက်တင်ဘာ",
                "အောက်တိုဘာ",
                "နိုဝင်ဘာ",
                "ဒီဇင်ဘာ",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        time_24hr: true,
    };
    fp$D.l10ns.my = Burmese;
    fp$D.l10ns;

    var fp$E = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Dutch = {
        weekdays: {
            shorthand: ["zo", "ma", "di", "wo", "do", "vr", "za"],
            longhand: [
                "zondag",
                "maandag",
                "dinsdag",
                "woensdag",
                "donderdag",
                "vrijdag",
                "zaterdag",
            ],
        },
        months: {
            shorthand: [
                "jan",
                "feb",
                "mrt",
                "apr",
                "mei",
                "jun",
                "jul",
                "aug",
                "sept",
                "okt",
                "nov",
                "dec",
            ],
            longhand: [
                "januari",
                "februari",
                "maart",
                "april",
                "mei",
                "juni",
                "juli",
                "augustus",
                "september",
                "oktober",
                "november",
                "december",
            ],
        },
        firstDayOfWeek: 1,
        weekAbbreviation: "wk",
        rangeSeparator: " t/m ",
        scrollTitle: "Scroll voor volgende / vorige",
        toggleTitle: "Klik om te wisselen",
        time_24hr: true,
        ordinal: function (nth) {
            if (nth === 1 || nth === 8 || nth >= 20)
                return "ste";
            return "de";
        },
    };
    fp$E.l10ns.nl = Dutch;
    fp$E.l10ns;

    var fp$F = typeof window !== 'undefined' && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var NorwegianNynorsk = {
        weekdays: {
            shorthand: ['Sø.', 'Må.', 'Ty.', 'On.', 'To.', 'Fr.', 'La.'],
            longhand: [
                'Søndag',
                'Måndag',
                'Tysdag',
                'Onsdag',
                'Torsdag',
                'Fredag',
                'Laurdag',
            ],
        },
        months: {
            shorthand: [
                'Jan',
                'Feb',
                'Mars',
                'Apr',
                'Mai',
                'Juni',
                'Juli',
                'Aug',
                'Sep',
                'Okt',
                'Nov',
                'Des',
            ],
            longhand: [
                'Januar',
                'Februar',
                'Mars',
                'April',
                'Mai',
                'Juni',
                'Juli',
                'August',
                'September',
                'Oktober',
                'November',
                'Desember',
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: ' til ',
        weekAbbreviation: 'Veke',
        scrollTitle: 'Scroll for å endre',
        toggleTitle: 'Klikk for å veksle',
        time_24hr: true,
        ordinal: function () {
            return '.';
        },
    };
    fp$F.l10ns.nn = NorwegianNynorsk;
    fp$F.l10ns;

    var fp$G = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Norwegian = {
        weekdays: {
            shorthand: ["Søn", "Man", "Tir", "Ons", "Tor", "Fre", "Lør"],
            longhand: [
                "Søndag",
                "Mandag",
                "Tirsdag",
                "Onsdag",
                "Torsdag",
                "Fredag",
                "Lørdag",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Mai",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Des",
            ],
            longhand: [
                "Januar",
                "Februar",
                "Mars",
                "April",
                "Mai",
                "Juni",
                "Juli",
                "August",
                "September",
                "Oktober",
                "November",
                "Desember",
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: " til ",
        weekAbbreviation: "Uke",
        scrollTitle: "Scroll for å endre",
        toggleTitle: "Klikk for å veksle",
        time_24hr: true,
        ordinal: function () {
            return ".";
        },
    };
    fp$G.l10ns.no = Norwegian;
    fp$G.l10ns;

    var fp$H = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Punjabi = {
        weekdays: {
            shorthand: ["ਐਤ", "ਸੋਮ", "ਮੰਗਲ", "ਬੁੱਧ", "ਵੀਰ", "ਸ਼ੁੱਕਰ", "ਸ਼ਨਿੱਚਰ"],
            longhand: [
                "ਐਤਵਾਰ",
                "ਸੋਮਵਾਰ",
                "ਮੰਗਲਵਾਰ",
                "ਬੁੱਧਵਾਰ",
                "ਵੀਰਵਾਰ",
                "ਸ਼ੁੱਕਰਵਾਰ",
                "ਸ਼ਨਿੱਚਰਵਾਰ",
            ],
        },
        months: {
            shorthand: [
                "ਜਨ",
                "ਫ਼ਰ",
                "ਮਾਰ",
                "ਅਪ੍ਰੈ",
                "ਮਈ",
                "ਜੂਨ",
                "ਜੁਲਾ",
                "ਅਗ",
                "ਸਤੰ",
                "ਅਕ",
                "ਨਵੰ",
                "ਦਸੰ",
            ],
            longhand: [
                "ਜਨਵਰੀ",
                "ਫ਼ਰਵਰੀ",
                "ਮਾਰਚ",
                "ਅਪ੍ਰੈਲ",
                "ਮਈ",
                "ਜੂਨ",
                "ਜੁਲਾਈ",
                "ਅਗਸਤ",
                "ਸਤੰਬਰ",
                "ਅਕਤੂਬਰ",
                "ਨਵੰਬਰ",
                "ਦਸੰਬਰ",
            ],
        },
        time_24hr: true,
    };
    fp$H.l10ns.pa = Punjabi;
    fp$H.l10ns;

    var fp$I = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Polish = {
        weekdays: {
            shorthand: ["Nd", "Pn", "Wt", "Śr", "Cz", "Pt", "So"],
            longhand: [
                "Niedziela",
                "Poniedziałek",
                "Wtorek",
                "Środa",
                "Czwartek",
                "Piątek",
                "Sobota",
            ],
        },
        months: {
            shorthand: [
                "Sty",
                "Lut",
                "Mar",
                "Kwi",
                "Maj",
                "Cze",
                "Lip",
                "Sie",
                "Wrz",
                "Paź",
                "Lis",
                "Gru",
            ],
            longhand: [
                "Styczeń",
                "Luty",
                "Marzec",
                "Kwiecień",
                "Maj",
                "Czerwiec",
                "Lipiec",
                "Sierpień",
                "Wrzesień",
                "Październik",
                "Listopad",
                "Grudzień",
            ],
        },
        rangeSeparator: " do ",
        weekAbbreviation: "tydz.",
        scrollTitle: "Przewiń, aby zwiększyć",
        toggleTitle: "Kliknij, aby przełączyć",
        firstDayOfWeek: 1,
        time_24hr: true,
        ordinal: function () {
            return ".";
        },
    };
    fp$I.l10ns.pl = Polish;
    fp$I.l10ns;

    var fp$J = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Portuguese = {
        weekdays: {
            shorthand: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
            longhand: [
                "Domingo",
                "Segunda-feira",
                "Terça-feira",
                "Quarta-feira",
                "Quinta-feira",
                "Sexta-feira",
                "Sábado",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Fev",
                "Mar",
                "Abr",
                "Mai",
                "Jun",
                "Jul",
                "Ago",
                "Set",
                "Out",
                "Nov",
                "Dez",
            ],
            longhand: [
                "Janeiro",
                "Fevereiro",
                "Março",
                "Abril",
                "Maio",
                "Junho",
                "Julho",
                "Agosto",
                "Setembro",
                "Outubro",
                "Novembro",
                "Dezembro",
            ],
        },
        rangeSeparator: " até ",
        time_24hr: true,
    };
    fp$J.l10ns.pt = Portuguese;
    fp$J.l10ns;

    var fp$K = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Romanian = {
        weekdays: {
            shorthand: ["Dum", "Lun", "Mar", "Mie", "Joi", "Vin", "Sâm"],
            longhand: [
                "Duminică",
                "Luni",
                "Marți",
                "Miercuri",
                "Joi",
                "Vineri",
                "Sâmbătă",
            ],
        },
        months: {
            shorthand: [
                "Ian",
                "Feb",
                "Mar",
                "Apr",
                "Mai",
                "Iun",
                "Iul",
                "Aug",
                "Sep",
                "Oct",
                "Noi",
                "Dec",
            ],
            longhand: [
                "Ianuarie",
                "Februarie",
                "Martie",
                "Aprilie",
                "Mai",
                "Iunie",
                "Iulie",
                "August",
                "Septembrie",
                "Octombrie",
                "Noiembrie",
                "Decembrie",
            ],
        },
        firstDayOfWeek: 1,
        time_24hr: true,
        ordinal: function () {
            return "";
        },
    };
    fp$K.l10ns.ro = Romanian;
    fp$K.l10ns;

    var fp$L = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Russian = {
        weekdays: {
            shorthand: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
            longhand: [
                "Воскресенье",
                "Понедельник",
                "Вторник",
                "Среда",
                "Четверг",
                "Пятница",
                "Суббота",
            ],
        },
        months: {
            shorthand: [
                "Янв",
                "Фев",
                "Март",
                "Апр",
                "Май",
                "Июнь",
                "Июль",
                "Авг",
                "Сен",
                "Окт",
                "Ноя",
                "Дек",
            ],
            longhand: [
                "Январь",
                "Февраль",
                "Март",
                "Апрель",
                "Май",
                "Июнь",
                "Июль",
                "Август",
                "Сентябрь",
                "Октябрь",
                "Ноябрь",
                "Декабрь",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "Нед.",
        scrollTitle: "Прокрутите для увеличения",
        toggleTitle: "Нажмите для переключения",
        amPM: ["ДП", "ПП"],
        yearAriaLabel: "Год",
        time_24hr: true,
    };
    fp$L.l10ns.ru = Russian;
    fp$L.l10ns;

    var fp$M = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Sinhala = {
        weekdays: {
            shorthand: ["ඉ", "ස", "අ", "බ", "බ්‍ර", "සි", "සෙ"],
            longhand: [
                "ඉරිදා",
                "සඳුදා",
                "අඟහරුවාදා",
                "බදාදා",
                "බ්‍රහස්පතින්දා",
                "සිකුරාදා",
                "සෙනසුරාදා",
            ],
        },
        months: {
            shorthand: [
                "ජන",
                "පෙබ",
                "මාර්",
                "අප්‍රේ",
                "මැයි",
                "ජුනි",
                "ජූලි",
                "අගෝ",
                "සැප්",
                "ඔක්",
                "නොවැ",
                "දෙසැ",
            ],
            longhand: [
                "ජනවාරි",
                "පෙබරවාරි",
                "මාර්තු",
                "අප්‍රේල්",
                "මැයි",
                "ජුනි",
                "ජූලි",
                "අගෝස්තු",
                "සැප්තැම්බර්",
                "ඔක්තෝබර්",
                "නොවැම්බර්",
                "දෙසැම්බර්",
            ],
        },
        time_24hr: true,
    };
    fp$M.l10ns.si = Sinhala;
    fp$M.l10ns;

    var fp$N = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Slovak = {
        weekdays: {
            shorthand: ["Ned", "Pon", "Ut", "Str", "Štv", "Pia", "Sob"],
            longhand: [
                "Nedeľa",
                "Pondelok",
                "Utorok",
                "Streda",
                "Štvrtok",
                "Piatok",
                "Sobota",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Máj",
                "Jún",
                "Júl",
                "Aug",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Január",
                "Február",
                "Marec",
                "Apríl",
                "Máj",
                "Jún",
                "Júl",
                "August",
                "September",
                "Október",
                "November",
                "December",
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: " do ",
        time_24hr: true,
        ordinal: function () {
            return ".";
        },
    };
    fp$N.l10ns.sk = Slovak;
    fp$N.l10ns;

    var fp$O = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Slovenian = {
        weekdays: {
            shorthand: ["Ned", "Pon", "Tor", "Sre", "Čet", "Pet", "Sob"],
            longhand: [
                "Nedelja",
                "Ponedeljek",
                "Torek",
                "Sreda",
                "Četrtek",
                "Petek",
                "Sobota",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Maj",
                "Jun",
                "Jul",
                "Avg",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Januar",
                "Februar",
                "Marec",
                "April",
                "Maj",
                "Junij",
                "Julij",
                "Avgust",
                "September",
                "Oktober",
                "November",
                "December",
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: " do ",
        time_24hr: true,
        ordinal: function () {
            return ".";
        },
    };
    fp$O.l10ns.sl = Slovenian;
    fp$O.l10ns;

    var fp$P = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Albanian = {
        weekdays: {
            shorthand: ["Di", "Hë", "Ma", "Më", "En", "Pr", "Sh"],
            longhand: [
                "E Diel",
                "E Hënë",
                "E Martë",
                "E Mërkurë",
                "E Enjte",
                "E Premte",
                "E Shtunë",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Shk",
                "Mar",
                "Pri",
                "Maj",
                "Qer",
                "Kor",
                "Gus",
                "Sht",
                "Tet",
                "Nën",
                "Dhj",
            ],
            longhand: [
                "Janar",
                "Shkurt",
                "Mars",
                "Prill",
                "Maj",
                "Qershor",
                "Korrik",
                "Gusht",
                "Shtator",
                "Tetor",
                "Nëntor",
                "Dhjetor",
            ],
        },
        time_24hr: true,
    };
    fp$P.l10ns.sq = Albanian;
    fp$P.l10ns;

    var fp$Q = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Serbian = {
        weekdays: {
            shorthand: ["Ned", "Pon", "Uto", "Sre", "Čet", "Pet", "Sub"],
            longhand: [
                "Nedelja",
                "Ponedeljak",
                "Utorak",
                "Sreda",
                "Četvrtak",
                "Petak",
                "Subota",
            ],
        },
        months: {
            shorthand: [
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "Maj",
                "Jun",
                "Jul",
                "Avg",
                "Sep",
                "Okt",
                "Nov",
                "Dec",
            ],
            longhand: [
                "Januar",
                "Februar",
                "Mart",
                "April",
                "Maj",
                "Jun",
                "Jul",
                "Avgust",
                "Septembar",
                "Oktobar",
                "Novembar",
                "Decembar",
            ],
        },
        firstDayOfWeek: 1,
        weekAbbreviation: "Ned.",
        rangeSeparator: " do ",
        time_24hr: true,
    };
    fp$Q.l10ns.sr = Serbian;
    fp$Q.l10ns;

    var fp$R = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Swedish = {
        firstDayOfWeek: 1,
        weekAbbreviation: "v",
        weekdays: {
            shorthand: ["sön", "mån", "tis", "ons", "tor", "fre", "lör"],
            longhand: [
                "söndag",
                "måndag",
                "tisdag",
                "onsdag",
                "torsdag",
                "fredag",
                "lördag",
            ],
        },
        months: {
            shorthand: [
                "jan",
                "feb",
                "mar",
                "apr",
                "maj",
                "jun",
                "jul",
                "aug",
                "sep",
                "okt",
                "nov",
                "dec",
            ],
            longhand: [
                "januari",
                "februari",
                "mars",
                "april",
                "maj",
                "juni",
                "juli",
                "augusti",
                "september",
                "oktober",
                "november",
                "december",
            ],
        },
        rangeSeparator: ' till ',
        time_24hr: true,
        ordinal: function () {
            return ".";
        },
    };
    fp$R.l10ns.sv = Swedish;
    fp$R.l10ns;

    var fp$S = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Thai = {
        weekdays: {
            shorthand: ["อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"],
            longhand: [
                "อาทิตย์",
                "จันทร์",
                "อังคาร",
                "พุธ",
                "พฤหัสบดี",
                "ศุกร์",
                "เสาร์",
            ],
        },
        months: {
            shorthand: [
                "ม.ค.",
                "ก.พ.",
                "มี.ค.",
                "เม.ย.",
                "พ.ค.",
                "มิ.ย.",
                "ก.ค.",
                "ส.ค.",
                "ก.ย.",
                "ต.ค.",
                "พ.ย.",
                "ธ.ค.",
            ],
            longhand: [
                "มกราคม",
                "กุมภาพันธ์",
                "มีนาคม",
                "เมษายน",
                "พฤษภาคม",
                "มิถุนายน",
                "กรกฎาคม",
                "สิงหาคม",
                "กันยายน",
                "ตุลาคม",
                "พฤศจิกายน",
                "ธันวาคม",
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: " ถึง ",
        scrollTitle: "เลื่อนเพื่อเพิ่มหรือลด",
        toggleTitle: "คลิกเพื่อเปลี่ยน",
        time_24hr: true,
        ordinal: function () {
            return "";
        },
    };
    fp$S.l10ns.th = Thai;
    fp$S.l10ns;

    var fp$T = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Turkish = {
        weekdays: {
            shorthand: ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"],
            longhand: [
                "Pazar",
                "Pazartesi",
                "Salı",
                "Çarşamba",
                "Perşembe",
                "Cuma",
                "Cumartesi",
            ],
        },
        months: {
            shorthand: [
                "Oca",
                "Şub",
                "Mar",
                "Nis",
                "May",
                "Haz",
                "Tem",
                "Ağu",
                "Eyl",
                "Eki",
                "Kas",
                "Ara",
            ],
            longhand: [
                "Ocak",
                "Şubat",
                "Mart",
                "Nisan",
                "Mayıs",
                "Haziran",
                "Temmuz",
                "Ağustos",
                "Eylül",
                "Ekim",
                "Kasım",
                "Aralık",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return ".";
        },
        rangeSeparator: " - ",
        weekAbbreviation: "Hf",
        scrollTitle: "Artırmak için kaydırın",
        toggleTitle: "Aç/Kapa",
        amPM: ["ÖÖ", "ÖS"],
        time_24hr: true,
    };
    fp$T.l10ns.tr = Turkish;
    fp$T.l10ns;

    var fp$U = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Ukrainian = {
        firstDayOfWeek: 1,
        weekdays: {
            shorthand: ["Нд", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
            longhand: [
                "Неділя",
                "Понеділок",
                "Вівторок",
                "Середа",
                "Четвер",
                "П'ятниця",
                "Субота",
            ],
        },
        months: {
            shorthand: [
                "Січ",
                "Лют",
                "Бер",
                "Кві",
                "Тра",
                "Чер",
                "Лип",
                "Сер",
                "Вер",
                "Жов",
                "Лис",
                "Гру",
            ],
            longhand: [
                "Січень",
                "Лютий",
                "Березень",
                "Квітень",
                "Травень",
                "Червень",
                "Липень",
                "Серпень",
                "Вересень",
                "Жовтень",
                "Листопад",
                "Грудень",
            ],
        },
        time_24hr: true,
    };
    fp$U.l10ns.uk = Ukrainian;
    fp$U.l10ns;

    var fp$V = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Uzbek = {
        weekdays: {
            shorthand: ["Якш", "Душ", "Сеш", "Чор", "Пай", "Жум", "Шан"],
            longhand: [
                "Якшанба",
                "Душанба",
                "Сешанба",
                "Чоршанба",
                "Пайшанба",
                "Жума",
                "Шанба",
            ],
        },
        months: {
            shorthand: [
                "Янв",
                "Фев",
                "Мар",
                "Апр",
                "Май",
                "Июн",
                "Июл",
                "Авг",
                "Сен",
                "Окт",
                "Ноя",
                "Дек",
            ],
            longhand: [
                "Январ",
                "Феврал",
                "Март",
                "Апрел",
                "Май",
                "Июн",
                "Июл",
                "Август",
                "Сентябр",
                "Октябр",
                "Ноябр",
                "Декабр",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "Ҳафта",
        scrollTitle: "Катталаштириш учун айлантиринг",
        toggleTitle: "Ўтиш учун босинг",
        amPM: ["AM", "PM"],
        yearAriaLabel: "Йил",
        time_24hr: true,
    };
    fp$V.l10ns.uz = Uzbek;
    fp$V.l10ns;

    var fp$W = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var UzbekLatin = {
        weekdays: {
            shorthand: ["Ya", "Du", "Se", "Cho", "Pa", "Ju", "Sha"],
            longhand: [
                "Yakshanba",
                "Dushanba",
                "Seshanba",
                "Chorshanba",
                "Payshanba",
                "Juma",
                "Shanba",
            ],
        },
        months: {
            shorthand: [
                "Yan",
                "Fev",
                "Mar",
                "Apr",
                "May",
                "Iyun",
                "Iyul",
                "Avg",
                "Sen",
                "Okt",
                "Noy",
                "Dek",
            ],
            longhand: [
                "Yanvar",
                "Fevral",
                "Mart",
                "Aprel",
                "May",
                "Iyun",
                "Iyul",
                "Avgust",
                "Sentabr",
                "Oktabr",
                "Noyabr",
                "Dekabr",
            ],
        },
        firstDayOfWeek: 1,
        ordinal: function () {
            return "";
        },
        rangeSeparator: " — ",
        weekAbbreviation: "Hafta",
        scrollTitle: "Kattalashtirish uchun aylantiring",
        toggleTitle: "O‘tish uchun bosing",
        amPM: ["AM", "PM"],
        yearAriaLabel: "Yil",
        time_24hr: true,
    };
    fp$W.l10ns["uz_latn"] = UzbekLatin;
    fp$W.l10ns;

    var fp$X = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Vietnamese = {
        weekdays: {
            shorthand: ["CN", "T2", "T3", "T4", "T5", "T6", "T7"],
            longhand: [
                "Chủ nhật",
                "Thứ hai",
                "Thứ ba",
                "Thứ tư",
                "Thứ năm",
                "Thứ sáu",
                "Thứ bảy",
            ],
        },
        months: {
            shorthand: [
                "Th1",
                "Th2",
                "Th3",
                "Th4",
                "Th5",
                "Th6",
                "Th7",
                "Th8",
                "Th9",
                "Th10",
                "Th11",
                "Th12",
            ],
            longhand: [
                "Tháng một",
                "Tháng hai",
                "Tháng ba",
                "Tháng tư",
                "Tháng năm",
                "Tháng sáu",
                "Tháng bảy",
                "Tháng tám",
                "Tháng chín",
                "Tháng mười",
                "Tháng mười một",
                "Tháng mười hai",
            ],
        },
        firstDayOfWeek: 1,
        rangeSeparator: " đến ",
    };
    fp$X.l10ns.vn = Vietnamese;
    fp$X.l10ns;

    var fp$Y = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var Mandarin = {
        weekdays: {
            shorthand: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
            longhand: [
                "星期日",
                "星期一",
                "星期二",
                "星期三",
                "星期四",
                "星期五",
                "星期六",
            ],
        },
        months: {
            shorthand: [
                "一月",
                "二月",
                "三月",
                "四月",
                "五月",
                "六月",
                "七月",
                "八月",
                "九月",
                "十月",
                "十一月",
                "十二月",
            ],
            longhand: [
                "一月",
                "二月",
                "三月",
                "四月",
                "五月",
                "六月",
                "七月",
                "八月",
                "九月",
                "十月",
                "十一月",
                "十二月",
            ],
        },
        rangeSeparator: " 至 ",
        weekAbbreviation: "周",
        scrollTitle: "滚动切换",
        toggleTitle: "点击切换 12/24 小时时制",
    };
    fp$Y.l10ns.zh = Mandarin;
    fp$Y.l10ns;

    var fp$Z = typeof window !== "undefined" && window.flatpickr !== undefined
        ? window.flatpickr
        : {
            l10ns: {},
        };
    var MandarinTraditional = {
        weekdays: {
            shorthand: ["週日", "週一", "週二", "週三", "週四", "週五", "週六"],
            longhand: [
                "星期日",
                "星期一",
                "星期二",
                "星期三",
                "星期四",
                "星期五",
                "星期六",
            ],
        },
        months: {
            shorthand: [
                "一月",
                "二月",
                "三月",
                "四月",
                "五月",
                "六月",
                "七月",
                "八月",
                "九月",
                "十月",
                "十一月",
                "十二月",
            ],
            longhand: [
                "一月",
                "二月",
                "三月",
                "四月",
                "五月",
                "六月",
                "七月",
                "八月",
                "九月",
                "十月",
                "十一月",
                "十二月",
            ],
        },
        rangeSeparator: " 至 ",
        weekAbbreviation: "週",
        scrollTitle: "滾動切換",
        toggleTitle: "點擊切換 12/24 小時時制",
    };
    fp$Z.l10ns.zh_tw = MandarinTraditional;
    fp$Z.l10ns;

    var l10n = {
        ar: Arabic,
        at: Austria,
        az: Azerbaijan,
        be: Belarusian,
        bg: Bulgarian,
        bn: Bangla,
        bs: Bosnian,
        ca: Catalan,
        ckb: Kurdish,
        cat: Catalan,
        cs: Czech,
        cy: Welsh,
        da: Danish,
        de: German,
        default: __assign({}, english),
        en: english,
        eo: Esperanto,
        es: Spanish,
        et: Estonian,
        fa: Persian,
        fi: Finnish,
        fo: Faroese,
        fr: French,
        gr: Greek,
        he: Hebrew,
        hi: Hindi,
        hr: Croatian,
        hu: Hungarian,
        hy: Armenian,
        id: Indonesian,
        is: Icelandic,
        it: Italian,
        ja: Japanese,
        ka: Georgian,
        ko: Korean,
        km: Khmer,
        kz: Kazakh,
        lt: Lithuanian,
        lv: Latvian,
        mk: Macedonian,
        mn: Mongolian,
        ms: Malaysian,
        my: Burmese,
        nl: Dutch,
        nn: NorwegianNynorsk,
        no: Norwegian,
        pa: Punjabi,
        pl: Polish,
        pt: Portuguese,
        ro: Romanian,
        ru: Russian,
        si: Sinhala,
        sk: Slovak,
        sl: Slovenian,
        sq: Albanian,
        sr: Serbian,
        sv: Swedish,
        th: Thai,
        tr: Turkish,
        uk: Ukrainian,
        vn: Vietnamese,
        zh: Mandarin,
        zh_tw: MandarinTraditional,
        uz: Uzbek,
        uz_latn: UzbekLatin,
    };

    exports.default = l10n;

    Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.is = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Icelandic = {
      weekdays: {
          shorthand: ["Sun", "Mán", "Þri", "Mið", "Fim", "Fös", "Lau"],
          longhand: [
              "Sunnudagur",
              "Mánudagur",
              "Þriðjudagur",
              "Miðvikudagur",
              "Fimmtudagur",
              "Föstudagur",
              "Laugardagur",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Maí",
              "Jún",
              "Júl",
              "Ágú",
              "Sep",
              "Okt",
              "Nóv",
              "Des",
          ],
          longhand: [
              "Janúar",
              "Febrúar",
              "Mars",
              "Apríl",
              "Maí",
              "Júní",
              "Júlí",
              "Ágúst",
              "September",
              "Október",
              "Nóvember",
              "Desember",
          ],
      },
      ordinal: function () {
          return ".";
      },
      firstDayOfWeek: 1,
      rangeSeparator: " til ",
      weekAbbreviation: "vika",
      yearAriaLabel: "Ár",
      time_24hr: true,
  };
  fp.l10ns.is = Icelandic;
  var is = fp.l10ns;

  exports.Icelandic = Icelandic;
  exports.default = is;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.it = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Italian = {
      weekdays: {
          shorthand: ["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"],
          longhand: [
              "Domenica",
              "Lunedì",
              "Martedì",
              "Mercoledì",
              "Giovedì",
              "Venerdì",
              "Sabato",
          ],
      },
      months: {
          shorthand: [
              "Gen",
              "Feb",
              "Mar",
              "Apr",
              "Mag",
              "Giu",
              "Lug",
              "Ago",
              "Set",
              "Ott",
              "Nov",
              "Dic",
          ],
          longhand: [
              "Gennaio",
              "Febbraio",
              "Marzo",
              "Aprile",
              "Maggio",
              "Giugno",
              "Luglio",
              "Agosto",
              "Settembre",
              "Ottobre",
              "Novembre",
              "Dicembre",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () { return "°"; },
      rangeSeparator: " al ",
      weekAbbreviation: "Se",
      scrollTitle: "Scrolla per aumentare",
      toggleTitle: "Clicca per cambiare",
      time_24hr: true,
  };
  fp.l10ns.it = Italian;
  var it = fp.l10ns;

  exports.Italian = Italian;
  exports.default = it;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ja = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Japanese = {
      weekdays: {
          shorthand: ["日", "月", "火", "水", "木", "金", "土"],
          longhand: [
              "日曜日",
              "月曜日",
              "火曜日",
              "水曜日",
              "木曜日",
              "金曜日",
              "土曜日",
          ],
      },
      months: {
          shorthand: [
              "1月",
              "2月",
              "3月",
              "4月",
              "5月",
              "6月",
              "7月",
              "8月",
              "9月",
              "10月",
              "11月",
              "12月",
          ],
          longhand: [
              "1月",
              "2月",
              "3月",
              "4月",
              "5月",
              "6月",
              "7月",
              "8月",
              "9月",
              "10月",
              "11月",
              "12月",
          ],
      },
      time_24hr: true,
      rangeSeparator: " から ",
      monthAriaLabel: "月",
      amPM: ["午前", "午後"],
      yearAriaLabel: "年",
      hourAriaLabel: "時間",
      minuteAriaLabel: "分",
  };
  fp.l10ns.ja = Japanese;
  var ja = fp.l10ns;

  exports.Japanese = Japanese;
  exports.default = ja;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ka = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Georgian = {
      weekdays: {
          shorthand: ["კვ", "ორ", "სა", "ოთ", "ხუ", "პა", "შა"],
          longhand: [
              "კვირა",
              "ორშაბათი",
              "სამშაბათი",
              "ოთხშაბათი",
              "ხუთშაბათი",
              "პარასკევი",
              "შაბათი",
          ],
      },
      months: {
          shorthand: [
              "იან",
              "თებ",
              "მარ",
              "აპრ",
              "მაი",
              "ივნ",
              "ივლ",
              "აგვ",
              "სექ",
              "ოქტ",
              "ნოე",
              "დეკ",
          ],
          longhand: [
              "იანვარი",
              "თებერვალი",
              "მარტი",
              "აპრილი",
              "მაისი",
              "ივნისი",
              "ივლისი",
              "აგვისტო",
              "სექტემბერი",
              "ოქტომბერი",
              "ნოემბერი",
              "დეკემბერი",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "კვ.",
      scrollTitle: "დასქროლეთ გასადიდებლად",
      toggleTitle: "დააკლიკეთ გადართვისთვის",
      amPM: ["AM", "PM"],
      yearAriaLabel: "წელი",
      time_24hr: true,
  };
  fp.l10ns.ka = Georgian;
  var ka = fp.l10ns;

  exports.Georgian = Georgian;
  exports.default = ka;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.km = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Khmer = {
      weekdays: {
          shorthand: ["អាទិត្យ", "ចន្ទ", "អង្គារ", "ពុធ", "ព្រហស.", "សុក្រ", "សៅរ៍"],
          longhand: [
              "អាទិត្យ",
              "ចន្ទ",
              "អង្គារ",
              "ពុធ",
              "ព្រហស្បតិ៍",
              "សុក្រ",
              "សៅរ៍",
          ],
      },
      months: {
          shorthand: [
              "មករា",
              "កុម្ភះ",
              "មីនា",
              "មេសា",
              "ឧសភា",
              "មិថុនា",
              "កក្កដា",
              "សីហា",
              "កញ្ញា",
              "តុលា",
              "វិច្ឆិកា",
              "ធ្នូ",
          ],
          longhand: [
              "មករា",
              "កុម្ភះ",
              "មីនា",
              "មេសា",
              "ឧសភា",
              "មិថុនា",
              "កក្កដា",
              "សីហា",
              "កញ្ញា",
              "តុលា",
              "វិច្ឆិកា",
              "ធ្នូ",
          ],
      },
      ordinal: function () {
          return "";
      },
      firstDayOfWeek: 1,
      rangeSeparator: " ដល់ ",
      weekAbbreviation: "សប្តាហ៍",
      scrollTitle: "រំកិលដើម្បីបង្កើន",
      toggleTitle: "ចុចដើម្បីផ្លាស់ប្ដូរ",
      yearAriaLabel: "ឆ្នាំ",
      time_24hr: true,
  };
  fp.l10ns.km = Khmer;
  var km = fp.l10ns;

  exports.Khmer = Khmer;
  exports.default = km;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ko = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Korean = {
      weekdays: {
          shorthand: ["일", "월", "화", "수", "목", "금", "토"],
          longhand: [
              "일요일",
              "월요일",
              "화요일",
              "수요일",
              "목요일",
              "금요일",
              "토요일",
          ],
      },
      months: {
          shorthand: [
              "1월",
              "2월",
              "3월",
              "4월",
              "5월",
              "6월",
              "7월",
              "8월",
              "9월",
              "10월",
              "11월",
              "12월",
          ],
          longhand: [
              "1월",
              "2월",
              "3월",
              "4월",
              "5월",
              "6월",
              "7월",
              "8월",
              "9월",
              "10월",
              "11월",
              "12월",
          ],
      },
      ordinal: function () {
          return "일";
      },
      rangeSeparator: " ~ ",
      amPM: ["오전", "오후"],
  };
  fp.l10ns.ko = Korean;
  var ko = fp.l10ns;

  exports.Korean = Korean;
  exports.default = ko;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.kz = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Kazakh = {
      weekdays: {
          shorthand: ["Жс", "Дс", "Сc", "Ср", "Бс", "Жм", "Сб"],
          longhand: [
              "Жексенбi",
              "Дүйсенбi",
              "Сейсенбi",
              "Сәрсенбi",
              "Бейсенбi",
              "Жұма",
              "Сенбi",
          ],
      },
      months: {
          shorthand: [
              "Қаң",
              "Ақп",
              "Нау",
              "Сәу",
              "Мам",
              "Мау",
              "Шiл",
              "Там",
              "Қыр",
              "Қаз",
              "Қар",
              "Жел",
          ],
          longhand: [
              "Қаңтар",
              "Ақпан",
              "Наурыз",
              "Сәуiр",
              "Мамыр",
              "Маусым",
              "Шiлде",
              "Тамыз",
              "Қыркүйек",
              "Қазан",
              "Қараша",
              "Желтоқсан",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "Апта",
      scrollTitle: "Үлкейту үшін айналдырыңыз",
      toggleTitle: "Ауыстыру үшін басыңыз",
      amPM: ["ТД", "ТК"],
      yearAriaLabel: "Жыл",
  };
  fp.l10ns.kz = Kazakh;
  var kz = fp.l10ns;

  exports.Kazakh = Kazakh;
  exports.default = kz;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.lt = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Lithuanian = {
      weekdays: {
          shorthand: ["S", "Pr", "A", "T", "K", "Pn", "Š"],
          longhand: [
              "Sekmadienis",
              "Pirmadienis",
              "Antradienis",
              "Trečiadienis",
              "Ketvirtadienis",
              "Penktadienis",
              "Šeštadienis",
          ],
      },
      months: {
          shorthand: [
              "Sau",
              "Vas",
              "Kov",
              "Bal",
              "Geg",
              "Bir",
              "Lie",
              "Rgp",
              "Rgs",
              "Spl",
              "Lap",
              "Grd",
          ],
          longhand: [
              "Sausis",
              "Vasaris",
              "Kovas",
              "Balandis",
              "Gegužė",
              "Birželis",
              "Liepa",
              "Rugpjūtis",
              "Rugsėjis",
              "Spalis",
              "Lapkritis",
              "Gruodis",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "-a";
      },
      rangeSeparator: " iki ",
      weekAbbreviation: "Sav",
      scrollTitle: "Keisti laiką pelės rateliu",
      toggleTitle: "Perjungti laiko formatą",
      time_24hr: true,
  };
  fp.l10ns.lt = Lithuanian;
  var lt = fp.l10ns;

  exports.Lithuanian = Lithuanian;
  exports.default = lt;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.lv = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Latvian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Sv", "Pr", "Ot", "Tr", "Ce", "Pk", "Se"],
          longhand: [
              "Svētdiena",
              "Pirmdiena",
              "Otrdiena",
              "Trešdiena",
              "Ceturtdiena",
              "Piektdiena",
              "Sestdiena",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Mai",
              "Jūn",
              "Jūl",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Janvāris",
              "Februāris",
              "Marts",
              "Aprīlis",
              "Maijs",
              "Jūnijs",
              "Jūlijs",
              "Augusts",
              "Septembris",
              "Oktobris",
              "Novembris",
              "Decembris",
          ],
      },
      rangeSeparator: " līdz ",
      time_24hr: true,
  };
  fp.l10ns.lv = Latvian;
  var lv = fp.l10ns;

  exports.Latvian = Latvian;
  exports.default = lv;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.mk = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Macedonian = {
      weekdays: {
          shorthand: ["Не", "По", "Вт", "Ср", "Че", "Пе", "Са"],
          longhand: [
              "Недела",
              "Понеделник",
              "Вторник",
              "Среда",
              "Четврток",
              "Петок",
              "Сабота",
          ],
      },
      months: {
          shorthand: [
              "Јан",
              "Фев",
              "Мар",
              "Апр",
              "Мај",
              "Јун",
              "Јул",
              "Авг",
              "Сеп",
              "Окт",
              "Ное",
              "Дек",
          ],
          longhand: [
              "Јануари",
              "Февруари",
              "Март",
              "Април",
              "Мај",
              "Јуни",
              "Јули",
              "Август",
              "Септември",
              "Октомври",
              "Ноември",
              "Декември",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "Нед.",
      rangeSeparator: " до ",
      time_24hr: true,
  };
  fp.l10ns.mk = Macedonian;
  var mk = fp.l10ns;

  exports.Macedonian = Macedonian;
  exports.default = mk;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.mn = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Mongolian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Да", "Мя", "Лх", "Пү", "Ба", "Бя", "Ня"],
          longhand: ["Даваа", "Мягмар", "Лхагва", "Пүрэв", "Баасан", "Бямба", "Ням"],
      },
      months: {
          shorthand: [
              "1-р сар",
              "2-р сар",
              "3-р сар",
              "4-р сар",
              "5-р сар",
              "6-р сар",
              "7-р сар",
              "8-р сар",
              "9-р сар",
              "10-р сар",
              "11-р сар",
              "12-р сар",
          ],
          longhand: [
              "Нэгдүгээр сар",
              "Хоёрдугаар сар",
              "Гуравдугаар сар",
              "Дөрөвдүгээр сар",
              "Тавдугаар сар",
              "Зургаадугаар сар",
              "Долдугаар сар",
              "Наймдугаар сар",
              "Есдүгээр сар",
              "Аравдугаар сар",
              "Арваннэгдүгээр сар",
              "Арванхоёрдугаар сар",
          ],
      },
      rangeSeparator: "-с ",
      time_24hr: true,
  };
  fp.l10ns.mn = Mongolian;
  var mn = fp.l10ns;

  exports.Mongolian = Mongolian;
  exports.default = mn;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ms = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Malaysian = {
      weekdays: {
          shorthand: ["Aha", "Isn", "Sel", "Rab", "Kha", "Jum", "Sab"],
          longhand: [
              "Ahad",
              "Isnin",
              "Selasa",
              "Rabu",
              "Khamis",
              "Jumaat",
              "Sabtu",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mac",
              "Apr",
              "Mei",
              "Jun",
              "Jul",
              "Ogo",
              "Sep",
              "Okt",
              "Nov",
              "Dis",
          ],
          longhand: [
              "Januari",
              "Februari",
              "Mac",
              "April",
              "Mei",
              "Jun",
              "Julai",
              "Ogos",
              "September",
              "Oktober",
              "November",
              "Disember",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
  };
  var ms = fp.l10ns;

  exports.Malaysian = Malaysian;
  exports.default = ms;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.my = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Burmese = {
      weekdays: {
          shorthand: ["နွေ", "လာ", "ဂါ", "ဟူး", "ကြာ", "သော", "နေ"],
          longhand: [
              "တနင်္ဂနွေ",
              "တနင်္လာ",
              "အင်္ဂါ",
              "ဗုဒ္ဓဟူး",
              "ကြာသပတေး",
              "သောကြာ",
              "စနေ",
          ],
      },
      months: {
          shorthand: [
              "ဇန်",
              "ဖေ",
              "မတ်",
              "ပြီ",
              "မေ",
              "ဇွန်",
              "လိုင်",
              "သြ",
              "စက်",
              "အောက်",
              "နို",
              "ဒီ",
          ],
          longhand: [
              "ဇန်နဝါရီ",
              "ဖေဖော်ဝါရီ",
              "မတ်",
              "ဧပြီ",
              "မေ",
              "ဇွန်",
              "ဇူလိုင်",
              "သြဂုတ်",
              "စက်တင်ဘာ",
              "အောက်တိုဘာ",
              "နိုဝင်ဘာ",
              "ဒီဇင်ဘာ",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      time_24hr: true,
  };
  fp.l10ns.my = Burmese;
  var my = fp.l10ns;

  exports.Burmese = Burmese;
  exports.default = my;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.nl = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Dutch = {
      weekdays: {
          shorthand: ["zo", "ma", "di", "wo", "do", "vr", "za"],
          longhand: [
              "zondag",
              "maandag",
              "dinsdag",
              "woensdag",
              "donderdag",
              "vrijdag",
              "zaterdag",
          ],
      },
      months: {
          shorthand: [
              "jan",
              "feb",
              "mrt",
              "apr",
              "mei",
              "jun",
              "jul",
              "aug",
              "sept",
              "okt",
              "nov",
              "dec",
          ],
          longhand: [
              "januari",
              "februari",
              "maart",
              "april",
              "mei",
              "juni",
              "juli",
              "augustus",
              "september",
              "oktober",
              "november",
              "december",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "wk",
      rangeSeparator: " t/m ",
      scrollTitle: "Scroll voor volgende / vorige",
      toggleTitle: "Klik om te wisselen",
      time_24hr: true,
      ordinal: function (nth) {
          if (nth === 1 || nth === 8 || nth >= 20)
              return "ste";
          return "de";
      },
  };
  fp.l10ns.nl = Dutch;
  var nl = fp.l10ns;

  exports.Dutch = Dutch;
  exports.default = nl;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.nn = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== 'undefined' && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var NorwegianNynorsk = {
      weekdays: {
          shorthand: ['Sø.', 'Må.', 'Ty.', 'On.', 'To.', 'Fr.', 'La.'],
          longhand: [
              'Søndag',
              'Måndag',
              'Tysdag',
              'Onsdag',
              'Torsdag',
              'Fredag',
              'Laurdag',
          ],
      },
      months: {
          shorthand: [
              'Jan',
              'Feb',
              'Mars',
              'Apr',
              'Mai',
              'Juni',
              'Juli',
              'Aug',
              'Sep',
              'Okt',
              'Nov',
              'Des',
          ],
          longhand: [
              'Januar',
              'Februar',
              'Mars',
              'April',
              'Mai',
              'Juni',
              'Juli',
              'August',
              'September',
              'Oktober',
              'November',
              'Desember',
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: ' til ',
      weekAbbreviation: 'Veke',
      scrollTitle: 'Scroll for å endre',
      toggleTitle: 'Klikk for å veksle',
      time_24hr: true,
      ordinal: function () {
          return '.';
      },
  };
  fp.l10ns.nn = NorwegianNynorsk;
  var nn = fp.l10ns;

  exports.NorwegianNynorsk = NorwegianNynorsk;
  exports.default = nn;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.no = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Norwegian = {
      weekdays: {
          shorthand: ["Søn", "Man", "Tir", "Ons", "Tor", "Fre", "Lør"],
          longhand: [
              "Søndag",
              "Mandag",
              "Tirsdag",
              "Onsdag",
              "Torsdag",
              "Fredag",
              "Lørdag",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Mai",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Des",
          ],
          longhand: [
              "Januar",
              "Februar",
              "Mars",
              "April",
              "Mai",
              "Juni",
              "Juli",
              "August",
              "September",
              "Oktober",
              "November",
              "Desember",
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: " til ",
      weekAbbreviation: "Uke",
      scrollTitle: "Scroll for å endre",
      toggleTitle: "Klikk for å veksle",
      time_24hr: true,
      ordinal: function () {
          return ".";
      },
  };
  fp.l10ns.no = Norwegian;
  var no = fp.l10ns;

  exports.Norwegian = Norwegian;
  exports.default = no;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.pa = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Punjabi = {
      weekdays: {
          shorthand: ["ਐਤ", "ਸੋਮ", "ਮੰਗਲ", "ਬੁੱਧ", "ਵੀਰ", "ਸ਼ੁੱਕਰ", "ਸ਼ਨਿੱਚਰ"],
          longhand: [
              "ਐਤਵਾਰ",
              "ਸੋਮਵਾਰ",
              "ਮੰਗਲਵਾਰ",
              "ਬੁੱਧਵਾਰ",
              "ਵੀਰਵਾਰ",
              "ਸ਼ੁੱਕਰਵਾਰ",
              "ਸ਼ਨਿੱਚਰਵਾਰ",
          ],
      },
      months: {
          shorthand: [
              "ਜਨ",
              "ਫ਼ਰ",
              "ਮਾਰ",
              "ਅਪ੍ਰੈ",
              "ਮਈ",
              "ਜੂਨ",
              "ਜੁਲਾ",
              "ਅਗ",
              "ਸਤੰ",
              "ਅਕ",
              "ਨਵੰ",
              "ਦਸੰ",
          ],
          longhand: [
              "ਜਨਵਰੀ",
              "ਫ਼ਰਵਰੀ",
              "ਮਾਰਚ",
              "ਅਪ੍ਰੈਲ",
              "ਮਈ",
              "ਜੂਨ",
              "ਜੁਲਾਈ",
              "ਅਗਸਤ",
              "ਸਤੰਬਰ",
              "ਅਕਤੂਬਰ",
              "ਨਵੰਬਰ",
              "ਦਸੰਬਰ",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.pa = Punjabi;
  var pa = fp.l10ns;

  exports.Punjabi = Punjabi;
  exports.default = pa;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.pl = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Polish = {
      weekdays: {
          shorthand: ["Nd", "Pn", "Wt", "Śr", "Cz", "Pt", "So"],
          longhand: [
              "Niedziela",
              "Poniedziałek",
              "Wtorek",
              "Środa",
              "Czwartek",
              "Piątek",
              "Sobota",
          ],
      },
      months: {
          shorthand: [
              "Sty",
              "Lut",
              "Mar",
              "Kwi",
              "Maj",
              "Cze",
              "Lip",
              "Sie",
              "Wrz",
              "Paź",
              "Lis",
              "Gru",
          ],
          longhand: [
              "Styczeń",
              "Luty",
              "Marzec",
              "Kwiecień",
              "Maj",
              "Czerwiec",
              "Lipiec",
              "Sierpień",
              "Wrzesień",
              "Październik",
              "Listopad",
              "Grudzień",
          ],
      },
      rangeSeparator: " do ",
      weekAbbreviation: "tydz.",
      scrollTitle: "Przewiń, aby zwiększyć",
      toggleTitle: "Kliknij, aby przełączyć",
      firstDayOfWeek: 1,
      time_24hr: true,
      ordinal: function () {
          return ".";
      },
  };
  fp.l10ns.pl = Polish;
  var pl = fp.l10ns;

  exports.Polish = Polish;
  exports.default = pl;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.pt = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Portuguese = {
      weekdays: {
          shorthand: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
          longhand: [
              "Domingo",
              "Segunda-feira",
              "Terça-feira",
              "Quarta-feira",
              "Quinta-feira",
              "Sexta-feira",
              "Sábado",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Fev",
              "Mar",
              "Abr",
              "Mai",
              "Jun",
              "Jul",
              "Ago",
              "Set",
              "Out",
              "Nov",
              "Dez",
          ],
          longhand: [
              "Janeiro",
              "Fevereiro",
              "Março",
              "Abril",
              "Maio",
              "Junho",
              "Julho",
              "Agosto",
              "Setembro",
              "Outubro",
              "Novembro",
              "Dezembro",
          ],
      },
      rangeSeparator: " até ",
      time_24hr: true,
  };
  fp.l10ns.pt = Portuguese;
  var pt = fp.l10ns;

  exports.Portuguese = Portuguese;
  exports.default = pt;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ro = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Romanian = {
      weekdays: {
          shorthand: ["Dum", "Lun", "Mar", "Mie", "Joi", "Vin", "Sâm"],
          longhand: [
              "Duminică",
              "Luni",
              "Marți",
              "Miercuri",
              "Joi",
              "Vineri",
              "Sâmbătă",
          ],
      },
      months: {
          shorthand: [
              "Ian",
              "Feb",
              "Mar",
              "Apr",
              "Mai",
              "Iun",
              "Iul",
              "Aug",
              "Sep",
              "Oct",
              "Noi",
              "Dec",
          ],
          longhand: [
              "Ianuarie",
              "Februarie",
              "Martie",
              "Aprilie",
              "Mai",
              "Iunie",
              "Iulie",
              "August",
              "Septembrie",
              "Octombrie",
              "Noiembrie",
              "Decembrie",
          ],
      },
      firstDayOfWeek: 1,
      time_24hr: true,
      ordinal: function () {
          return "";
      },
  };
  fp.l10ns.ro = Romanian;
  var ro = fp.l10ns;

  exports.Romanian = Romanian;
  exports.default = ro;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.ru = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Russian = {
      weekdays: {
          shorthand: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
          longhand: [
              "Воскресенье",
              "Понедельник",
              "Вторник",
              "Среда",
              "Четверг",
              "Пятница",
              "Суббота",
          ],
      },
      months: {
          shorthand: [
              "Янв",
              "Фев",
              "Март",
              "Апр",
              "Май",
              "Июнь",
              "Июль",
              "Авг",
              "Сен",
              "Окт",
              "Ноя",
              "Дек",
          ],
          longhand: [
              "Январь",
              "Февраль",
              "Март",
              "Апрель",
              "Май",
              "Июнь",
              "Июль",
              "Август",
              "Сентябрь",
              "Октябрь",
              "Ноябрь",
              "Декабрь",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "Нед.",
      scrollTitle: "Прокрутите для увеличения",
      toggleTitle: "Нажмите для переключения",
      amPM: ["ДП", "ПП"],
      yearAriaLabel: "Год",
      time_24hr: true,
  };
  fp.l10ns.ru = Russian;
  var ru = fp.l10ns;

  exports.Russian = Russian;
  exports.default = ru;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.si = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Sinhala = {
      weekdays: {
          shorthand: ["ඉ", "ස", "අ", "බ", "බ්‍ර", "සි", "සෙ"],
          longhand: [
              "ඉරිදා",
              "සඳුදා",
              "අඟහරුවාදා",
              "බදාදා",
              "බ්‍රහස්පතින්දා",
              "සිකුරාදා",
              "සෙනසුරාදා",
          ],
      },
      months: {
          shorthand: [
              "ජන",
              "පෙබ",
              "මාර්",
              "අප්‍රේ",
              "මැයි",
              "ජුනි",
              "ජූලි",
              "අගෝ",
              "සැප්",
              "ඔක්",
              "නොවැ",
              "දෙසැ",
          ],
          longhand: [
              "ජනවාරි",
              "පෙබරවාරි",
              "මාර්තු",
              "අප්‍රේල්",
              "මැයි",
              "ජුනි",
              "ජූලි",
              "අගෝස්තු",
              "සැප්තැම්බර්",
              "ඔක්තෝබර්",
              "නොවැම්බර්",
              "දෙසැම්බර්",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.si = Sinhala;
  var si = fp.l10ns;

  exports.Sinhala = Sinhala;
  exports.default = si;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.sk = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Slovak = {
      weekdays: {
          shorthand: ["Ned", "Pon", "Ut", "Str", "Štv", "Pia", "Sob"],
          longhand: [
              "Nedeľa",
              "Pondelok",
              "Utorok",
              "Streda",
              "Štvrtok",
              "Piatok",
              "Sobota",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Máj",
              "Jún",
              "Júl",
              "Aug",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Január",
              "Február",
              "Marec",
              "Apríl",
              "Máj",
              "Jún",
              "Júl",
              "August",
              "September",
              "Október",
              "November",
              "December",
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: " do ",
      time_24hr: true,
      ordinal: function () {
          return ".";
      },
  };
  fp.l10ns.sk = Slovak;
  var sk = fp.l10ns;

  exports.Slovak = Slovak;
  exports.default = sk;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.sl = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Slovenian = {
      weekdays: {
          shorthand: ["Ned", "Pon", "Tor", "Sre", "Čet", "Pet", "Sob"],
          longhand: [
              "Nedelja",
              "Ponedeljek",
              "Torek",
              "Sreda",
              "Četrtek",
              "Petek",
              "Sobota",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Maj",
              "Jun",
              "Jul",
              "Avg",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Januar",
              "Februar",
              "Marec",
              "April",
              "Maj",
              "Junij",
              "Julij",
              "Avgust",
              "September",
              "Oktober",
              "November",
              "December",
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: " do ",
      time_24hr: true,
      ordinal: function () {
          return ".";
      },
  };
  fp.l10ns.sl = Slovenian;
  var sl = fp.l10ns;

  exports.Slovenian = Slovenian;
  exports.default = sl;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.sq = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Albanian = {
      weekdays: {
          shorthand: ["Di", "Hë", "Ma", "Më", "En", "Pr", "Sh"],
          longhand: [
              "E Diel",
              "E Hënë",
              "E Martë",
              "E Mërkurë",
              "E Enjte",
              "E Premte",
              "E Shtunë",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Shk",
              "Mar",
              "Pri",
              "Maj",
              "Qer",
              "Kor",
              "Gus",
              "Sht",
              "Tet",
              "Nën",
              "Dhj",
          ],
          longhand: [
              "Janar",
              "Shkurt",
              "Mars",
              "Prill",
              "Maj",
              "Qershor",
              "Korrik",
              "Gusht",
              "Shtator",
              "Tetor",
              "Nëntor",
              "Dhjetor",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.sq = Albanian;
  var sq = fp.l10ns;

  exports.Albanian = Albanian;
  exports.default = sq;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global['sr-cyr'] = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var SerbianCyrillic = {
      weekdays: {
          shorthand: ["Нед", "Пон", "Уто", "Сре", "Чет", "Пет", "Суб"],
          longhand: [
              "Недеља",
              "Понедељак",
              "Уторак",
              "Среда",
              "Четвртак",
              "Петак",
              "Субота",
          ],
      },
      months: {
          shorthand: [
              "Јан",
              "Феб",
              "Мар",
              "Апр",
              "Мај",
              "Јун",
              "Јул",
              "Авг",
              "Сеп",
              "Окт",
              "Нов",
              "Дец",
          ],
          longhand: [
              "Јануар",
              "Фебруар",
              "Март",
              "Април",
              "Мај",
              "Јун",
              "Јул",
              "Август",
              "Септембар",
              "Октобар",
              "Новембар",
              "Децембар",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "Нед.",
      rangeSeparator: " до ",
  };
  fp.l10ns.sr = SerbianCyrillic;
  var srCyr = fp.l10ns;

  exports.SerbianCyrillic = SerbianCyrillic;
  exports.default = srCyr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.sr = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Serbian = {
      weekdays: {
          shorthand: ["Ned", "Pon", "Uto", "Sre", "Čet", "Pet", "Sub"],
          longhand: [
              "Nedelja",
              "Ponedeljak",
              "Utorak",
              "Sreda",
              "Četvrtak",
              "Petak",
              "Subota",
          ],
      },
      months: {
          shorthand: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "Maj",
              "Jun",
              "Jul",
              "Avg",
              "Sep",
              "Okt",
              "Nov",
              "Dec",
          ],
          longhand: [
              "Januar",
              "Februar",
              "Mart",
              "April",
              "Maj",
              "Jun",
              "Jul",
              "Avgust",
              "Septembar",
              "Oktobar",
              "Novembar",
              "Decembar",
          ],
      },
      firstDayOfWeek: 1,
      weekAbbreviation: "Ned.",
      rangeSeparator: " do ",
      time_24hr: true,
  };
  fp.l10ns.sr = Serbian;
  var sr = fp.l10ns;

  exports.Serbian = Serbian;
  exports.default = sr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.sv = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Swedish = {
      firstDayOfWeek: 1,
      weekAbbreviation: "v",
      weekdays: {
          shorthand: ["sön", "mån", "tis", "ons", "tor", "fre", "lör"],
          longhand: [
              "söndag",
              "måndag",
              "tisdag",
              "onsdag",
              "torsdag",
              "fredag",
              "lördag",
          ],
      },
      months: {
          shorthand: [
              "jan",
              "feb",
              "mar",
              "apr",
              "maj",
              "jun",
              "jul",
              "aug",
              "sep",
              "okt",
              "nov",
              "dec",
          ],
          longhand: [
              "januari",
              "februari",
              "mars",
              "april",
              "maj",
              "juni",
              "juli",
              "augusti",
              "september",
              "oktober",
              "november",
              "december",
          ],
      },
      rangeSeparator: ' till ',
      time_24hr: true,
      ordinal: function () {
          return ".";
      },
  };
  fp.l10ns.sv = Swedish;
  var sv = fp.l10ns;

  exports.Swedish = Swedish;
  exports.default = sv;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.th = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Thai = {
      weekdays: {
          shorthand: ["อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"],
          longhand: [
              "อาทิตย์",
              "จันทร์",
              "อังคาร",
              "พุธ",
              "พฤหัสบดี",
              "ศุกร์",
              "เสาร์",
          ],
      },
      months: {
          shorthand: [
              "ม.ค.",
              "ก.พ.",
              "มี.ค.",
              "เม.ย.",
              "พ.ค.",
              "มิ.ย.",
              "ก.ค.",
              "ส.ค.",
              "ก.ย.",
              "ต.ค.",
              "พ.ย.",
              "ธ.ค.",
          ],
          longhand: [
              "มกราคม",
              "กุมภาพันธ์",
              "มีนาคม",
              "เมษายน",
              "พฤษภาคม",
              "มิถุนายน",
              "กรกฎาคม",
              "สิงหาคม",
              "กันยายน",
              "ตุลาคม",
              "พฤศจิกายน",
              "ธันวาคม",
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: " ถึง ",
      scrollTitle: "เลื่อนเพื่อเพิ่มหรือลด",
      toggleTitle: "คลิกเพื่อเปลี่ยน",
      time_24hr: true,
      ordinal: function () {
          return "";
      },
  };
  fp.l10ns.th = Thai;
  var th = fp.l10ns;

  exports.Thai = Thai;
  exports.default = th;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.tr = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Turkish = {
      weekdays: {
          shorthand: ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"],
          longhand: [
              "Pazar",
              "Pazartesi",
              "Salı",
              "Çarşamba",
              "Perşembe",
              "Cuma",
              "Cumartesi",
          ],
      },
      months: {
          shorthand: [
              "Oca",
              "Şub",
              "Mar",
              "Nis",
              "May",
              "Haz",
              "Tem",
              "Ağu",
              "Eyl",
              "Eki",
              "Kas",
              "Ara",
          ],
          longhand: [
              "Ocak",
              "Şubat",
              "Mart",
              "Nisan",
              "Mayıs",
              "Haziran",
              "Temmuz",
              "Ağustos",
              "Eylül",
              "Ekim",
              "Kasım",
              "Aralık",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return ".";
      },
      rangeSeparator: " - ",
      weekAbbreviation: "Hf",
      scrollTitle: "Artırmak için kaydırın",
      toggleTitle: "Aç/Kapa",
      amPM: ["ÖÖ", "ÖS"],
      time_24hr: true,
  };
  fp.l10ns.tr = Turkish;
  var tr = fp.l10ns;

  exports.Turkish = Turkish;
  exports.default = tr;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.uk = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Ukrainian = {
      firstDayOfWeek: 1,
      weekdays: {
          shorthand: ["Нд", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
          longhand: [
              "Неділя",
              "Понеділок",
              "Вівторок",
              "Середа",
              "Четвер",
              "П'ятниця",
              "Субота",
          ],
      },
      months: {
          shorthand: [
              "Січ",
              "Лют",
              "Бер",
              "Кві",
              "Тра",
              "Чер",
              "Лип",
              "Сер",
              "Вер",
              "Жов",
              "Лис",
              "Гру",
          ],
          longhand: [
              "Січень",
              "Лютий",
              "Березень",
              "Квітень",
              "Травень",
              "Червень",
              "Липень",
              "Серпень",
              "Вересень",
              "Жовтень",
              "Листопад",
              "Грудень",
          ],
      },
      time_24hr: true,
  };
  fp.l10ns.uk = Ukrainian;
  var uk = fp.l10ns;

  exports.Ukrainian = Ukrainian;
  exports.default = uk;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.uz = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Uzbek = {
      weekdays: {
          shorthand: ["Якш", "Душ", "Сеш", "Чор", "Пай", "Жум", "Шан"],
          longhand: [
              "Якшанба",
              "Душанба",
              "Сешанба",
              "Чоршанба",
              "Пайшанба",
              "Жума",
              "Шанба",
          ],
      },
      months: {
          shorthand: [
              "Янв",
              "Фев",
              "Мар",
              "Апр",
              "Май",
              "Июн",
              "Июл",
              "Авг",
              "Сен",
              "Окт",
              "Ноя",
              "Дек",
          ],
          longhand: [
              "Январ",
              "Феврал",
              "Март",
              "Апрел",
              "Май",
              "Июн",
              "Июл",
              "Август",
              "Сентябр",
              "Октябр",
              "Ноябр",
              "Декабр",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "Ҳафта",
      scrollTitle: "Катталаштириш учун айлантиринг",
      toggleTitle: "Ўтиш учун босинг",
      amPM: ["AM", "PM"],
      yearAriaLabel: "Йил",
      time_24hr: true,
  };
  fp.l10ns.uz = Uzbek;
  var uz = fp.l10ns;

  exports.Uzbek = Uzbek;
  exports.default = uz;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.uz_latn = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var UzbekLatin = {
      weekdays: {
          shorthand: ["Ya", "Du", "Se", "Cho", "Pa", "Ju", "Sha"],
          longhand: [
              "Yakshanba",
              "Dushanba",
              "Seshanba",
              "Chorshanba",
              "Payshanba",
              "Juma",
              "Shanba",
          ],
      },
      months: {
          shorthand: [
              "Yan",
              "Fev",
              "Mar",
              "Apr",
              "May",
              "Iyun",
              "Iyul",
              "Avg",
              "Sen",
              "Okt",
              "Noy",
              "Dek",
          ],
          longhand: [
              "Yanvar",
              "Fevral",
              "Mart",
              "Aprel",
              "May",
              "Iyun",
              "Iyul",
              "Avgust",
              "Sentabr",
              "Oktabr",
              "Noyabr",
              "Dekabr",
          ],
      },
      firstDayOfWeek: 1,
      ordinal: function () {
          return "";
      },
      rangeSeparator: " — ",
      weekAbbreviation: "Hafta",
      scrollTitle: "Kattalashtirish uchun aylantiring",
      toggleTitle: "O‘tish uchun bosing",
      amPM: ["AM", "PM"],
      yearAriaLabel: "Yil",
      time_24hr: true,
  };
  fp.l10ns["uz_latn"] = UzbekLatin;
  var uz_latn = fp.l10ns;

  exports.UzbekLatin = UzbekLatin;
  exports.default = uz_latn;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.vn = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Vietnamese = {
      weekdays: {
          shorthand: ["CN", "T2", "T3", "T4", "T5", "T6", "T7"],
          longhand: [
              "Chủ nhật",
              "Thứ hai",
              "Thứ ba",
              "Thứ tư",
              "Thứ năm",
              "Thứ sáu",
              "Thứ bảy",
          ],
      },
      months: {
          shorthand: [
              "Th1",
              "Th2",
              "Th3",
              "Th4",
              "Th5",
              "Th6",
              "Th7",
              "Th8",
              "Th9",
              "Th10",
              "Th11",
              "Th12",
          ],
          longhand: [
              "Tháng một",
              "Tháng hai",
              "Tháng ba",
              "Tháng tư",
              "Tháng năm",
              "Tháng sáu",
              "Tháng bảy",
              "Tháng tám",
              "Tháng chín",
              "Tháng mười",
              "Tháng mười một",
              "Tháng mười hai",
          ],
      },
      firstDayOfWeek: 1,
      rangeSeparator: " đến ",
  };
  fp.l10ns.vn = Vietnamese;
  var vn = fp.l10ns;

  exports.Vietnamese = Vietnamese;
  exports.default = vn;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global['zh-tw'] = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var MandarinTraditional = {
      weekdays: {
          shorthand: ["週日", "週一", "週二", "週三", "週四", "週五", "週六"],
          longhand: [
              "星期日",
              "星期一",
              "星期二",
              "星期三",
              "星期四",
              "星期五",
              "星期六",
          ],
      },
      months: {
          shorthand: [
              "一月",
              "二月",
              "三月",
              "四月",
              "五月",
              "六月",
              "七月",
              "八月",
              "九月",
              "十月",
              "十一月",
              "十二月",
          ],
          longhand: [
              "一月",
              "二月",
              "三月",
              "四月",
              "五月",
              "六月",
              "七月",
              "八月",
              "九月",
              "十月",
              "十一月",
              "十二月",
          ],
      },
      rangeSeparator: " 至 ",
      weekAbbreviation: "週",
      scrollTitle: "滾動切換",
      toggleTitle: "點擊切換 12/24 小時時制",
  };
  fp.l10ns.zh_tw = MandarinTraditional;
  var zhTw = fp.l10ns;

  exports.MandarinTraditional = MandarinTraditional;
  exports.default = zhTw;

  Object.defineProperty(exports, '__esModule', { value: true });

})));

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.zh = {}));
}(this, (function (exports) { 'use strict';

  var fp = typeof window !== "undefined" && window.flatpickr !== undefined
      ? window.flatpickr
      : {
          l10ns: {},
      };
  var Mandarin = {
      weekdays: {
          shorthand: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
          longhand: [
              "星期日",
              "星期一",
              "星期二",
              "星期三",
              "星期四",
              "星期五",
              "星期六",
          ],
      },
      months: {
          shorthand: [
              "一月",
              "二月",
              "三月",
              "四月",
              "五月",
              "六月",
              "七月",
              "八月",
              "九月",
              "十月",
              "十一月",
              "十二月",
          ],
          longhand: [
              "一月",
              "二月",
              "三月",
              "四月",
              "五月",
              "六月",
              "七月",
              "八月",
              "九月",
              "十月",
              "十一月",
              "十二月",
          ],
      },
      rangeSeparator: " 至 ",
      weekAbbreviation: "周",
      scrollTitle: "滚动切换",
      toggleTitle: "点击切换 12/24 小时时制",
  };
  fp.l10ns.zh = Mandarin;
  var zh = fp.l10ns;

  exports.Mandarin = Mandarin;
  exports.default = zh;

  Object.defineProperty(exports, '__esModule', { value: true });

})));
