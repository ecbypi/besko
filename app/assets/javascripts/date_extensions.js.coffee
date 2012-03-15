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
