(function() {
  // borrowed from https://gist.github.com/1005938
  var shortDays, days, shortMonths, months, callbacks, dateExtensions;

  shortDays   = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ];
  days        = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
  shortMonths = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
  months      = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

  zeropad = function(n) { return n > 9 ? n : "0" + n };

  var callbacks = {
    // Short day name (Sun-Sat)
    a: function (t) {
      return shortDays[t.getDay()];
    },
    // Long day name (Sunday-Saturday)
    A: function (t) {
      return days[t.getDay()];
    },
    // Short month name (Jan-Dec)
    b: function (t) {
      return shortMonths[t.getMonth()];
    },
    // Long month name (January-December)
    B: function (t) {
      return months[t.getMonth()];
    },
    // String representation (Thu Dec 23 2010 11:48:54 GMT-0800 (PST))
    c: function (t) {
      return t.toString();
    },
    // Two-digit day of the month (01-31)
    d: function (t) {
      return zeropad(t.getDate());
    },
    // Day of the month (1-31)
    D: function (t) {
      return t.getDate();
    },
    // Two digit hour in 24-hour format (00-23)
    H: function (t) {
      return zeropad(t.getHours());
    },
    // Hour in 24-hour format (0-23)
    i: function (t) {
      return t.getHours();
    },
    // Two digit hour in 12-hour format (01-12)
    I: function (t) {
      return zeropad(callbacks.l(t));
    },
    // Hour in 12-hour format (1-12)
    l: function (t) {
      var hour = t.getHours() % 12;
      return hour === 0 ? 12 : hour;
    },
    // Two digit month (01-12)
    m: function (t) {
      return zeropad(t.getMonth() + 1);
    },
    // Two digit minutes (00-59)
    M: function (t) {
      return zeropad(t.getMinutes());
    },
    // am or pm
    p: function (t) {
      return callbacks.H(t) < 12 ? 'am' : 'pm';
    },
    // AM or PM
    P: function (t) {
      return callbacks.H(t) < 12 ? 'AM' : 'PM';
    },
    // Two digit seconds (00-61)
    S: function (t) {
      return zeropad(t.getSeconds());
    },
    // Zero-based day of the week (0-6)
    w: function (t) {
      return t.getDay();
    },
    // Locale-specific date representation
    x: function (t) {
      return t.toLocaleDateString();
    },
    // Locale-specific time representation
    X: function (t) {
      return t.toLocaleTimeString();
    },
    // Year without century (00-99)
    y: function (t) {
      return zeropad(callbacks.Y(t) % 100);
    },
    // Year with century
    Y: function (t) {
      return t.getFullYear();
    },
    // Timezone offset (+0000)
    Z: function (t) {
      if (t.getTimezoneOffset() > 0) {
        return "-" + zeropad(t.getTimezoneOffset() / 60) + "00";
      } else {
        return "+" + zeropad(Math.abs(t.getTimezoneOffset()) / 60) + "00";
      }
    },
    // A percent sign
    '%': function(t) {
      return '%';
    }
  };

  dateExtensions = {
    getUTCDayName: function() {
      return this.strftime('%A');
    },
    getUTCMonthName: function() {
      return this.strftime('%B');
    },
    increment: function(days) {
      days = days || 1;
      return Besko.Date(Date.parse(this) + (86400000 * days));
    },
    decrement: function(days) {
      days = days || 1;
      return this.increment(-days);
    },
    strftime: function(format) {
      for (var key in callbacks) {
        regexp = new RegExp("%" + key, "g");
        format = format.replace(regexp, callbacks[key](this));
      }
      return format;
    }
  };

  Besko.Date = function(date) {
    var offsetHour;

    // if creating a date from 'yyyy-mm-dd' iso string, time zone defaults to GMT
    // this figures out the current offset and adds the offset hour to the string
    // creating a date at midnight in the timezone desired
    if ( typeof date === 'string' && date.match(/^\d{4}-\d{2}-\d{2}$/) ) {
      offsetHour = zeropad(String(new Date().getTimezoneOffset() / 60));
      date += "T" + offsetHour + ":00:00.000Z";
    }

    date = typeof date === 'undefined' ? new Date() : new Date(date)
    return _.extend(date, dateExtensions)
  };
})();