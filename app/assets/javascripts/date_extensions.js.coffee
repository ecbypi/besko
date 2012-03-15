@DateExtensions =
  getUTCDayName: ->
    days = [
      'Sunday'
      'Monday'
      'Tuesday'
      'Wednesday'
      'Thursday'
      'Friday'
      'Saturday'
    ]
    days[@getUTCDay()]

  getUTCMonthName: ->
    months = [
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December'
    ]
    months[@getUTCMonth()]

  increment: (days=1) ->
    _.extend(new Date(Date.parse(this) + (86400000 * days)), DateExtensions)

  decrement: (days=1) ->
    @increment(-days)

  toISODateString: ->
    @toISOString().replace(/T.*Z$/,'')
