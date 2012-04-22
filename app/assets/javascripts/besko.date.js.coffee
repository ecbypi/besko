# borrowed from https://gist.github.com/1005938

shortDays = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
days = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
shortMonths = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

zeropad = (n) -> (if n > 9 then n else "0" + n)

callbacks =
  a: (t) -> shortDays[t.getDay()]
  A: (t) -> days[t.getDay()]
  b: (t) -> shortMonths[t.getMonth()]
  B: (t) -> months[t.getMonth()]
  c: (t) -> t.toString()
  d: (t) -> zeropad t.getDate()
  D: (t) -> t.getDate()
  H: (t) -> zeropad t.getHours()
  i: (t) -> t.getHours()
  I: (t) -> zeropad callbacks.l(t)
  l: (t) ->
    hour = t.getHours() % 12
    (if hour is 0 then 12 else hour)
  m: (t) -> zeropad t.getMonth() + 1
  M: (t) -> zeropad t.getMinutes()
  p: (t) -> (if callbacks.H< 12 then "am" else "pm")
  P: (t) -> (if callbacks.H< 12 then "AM" else "PM")
  S: (t) -> zeropad t.getSeconds()
  w: (t) -> t.getDay()
  x: (t) -> t.toLocaleDateString()
  X: (t) -> t.toLocaleTimeString()
  y: (t) -> zeropad callbacks.Y% 100
  Y: (t) -> t.getFullYear()
  Z: (t) ->
    if t.getTimezoneOffset() > 0
      "-" + zeropad(t.getTimezoneOffset() / 60) + "00"
    else
      "+" + zeropad(Math.abs(t.getTimezoneOffset()) / 60) + "00"
  "%": (t) -> "%"

dateExtensions =
  getUTCDayName:      -> days[@getUTCDay()]
  getUTCMonthName:    -> months[@getUTCMonth()]
  increment: (days=1) -> Besko.Date(Date.parse(this) + (86400000 * days))
  decrement: (days=1) -> @increment(-days)
  strftime: (format)  ->
    for key of callbacks
      regexp = new RegExp("%" + key, "g")
      format = format.replace(regexp, callbacks[key](this))
    format

Besko.Date = (date) ->
    # if creating a date from 'yyyy-mm-dd' iso string, time zone defaults to GMT
    # this figures out the current offset and adds the offset hour to the string
    # creating a date at midnight in the timezone desired
    if typeof date == 'string' && date.match /^\d{4}-\d{2}-\d{2}$/
      offsetHour = String(new Date().getTimezoneOffset() / 60)
      offsetHour = '0' + offsetHour if offsetHour.length == 1
      date += "T#{offsetHour}:00:00.000Z"

    date = if !date? then new Date() else new Date(date)
    _.extend(date, dateExtensions)

