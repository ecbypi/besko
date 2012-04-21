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


  extendDate: (date) ->
    _.extend(date, DateExtensions)

$ ->
  Besko.init()
