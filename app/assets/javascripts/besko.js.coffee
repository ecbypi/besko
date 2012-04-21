#= require underscore
#= require backbone
#= require backbone.authtokenadapter
#= require backbone-forms
#= require jquery-ui-editors
#= require backbone-form-templates
#= require backbone-support

#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree ../templates

dateExtensions =
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
    Besko.Date(Date.parse(this) + (86400000 * days))

  decrement: (days=1) ->
    @increment(-days)

  toISODateString: ->
    @toISOString().replace(/T.*Z$/,'')

@Besko =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->

    new Besko.Routers.Registrations()
    new Besko.Routers.Deliveries()
    unless Backbone.history.started?
      Backbone.history.start pushState: true
      Backbone.history.started = true

  bootstrap: (ctor) ->
    bootstrap = $('script#bootstrap')
    if bootstrap.length > 0
      tmp = document.createElement('div')
      tmp.innerHTML = bootstrap.text()
      json = JSON.parse(tmp.innerHTML)
      new ctor(json.data)
    else
      new ctor()


  Date: (date) ->
    # if creating a date from 'yyyy-mm-dd' iso string, time zone defaults to GMT
    # this figures out the current offset and adds the offset hour to the string
    # creating a date at midnight in the timezone desired
    if typeof date == 'string' && date.match /^\d{4}-\d{2}-\d{2}$/
      offsetHour = String(new Date().getTimezoneOffset() / 60)
      offsetHour = '0' + offsetHour if offsetHour.length == 1
      date += "T#{offsetHour}:00:00.000Z"

    date = if !date? then new Date() else new Date(date)
    _.extend(date, dateExtensions)

$ ->
  Besko.init()
