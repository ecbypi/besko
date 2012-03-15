#= require underscore
#= require backbone
#= require backbone.authtokenadapter
#= require backbone-forms-rails/backbone-forms
#= require backbone-forms-rails/jquery-ui-editors
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

  parse: (text, ctor) ->
    tmp = document.createElement('div')
    tmp.innerHTML = text
    json = JSON.parse(tmp.innerHTML)
    new ctor json.data

$ ->
  Besko.init()
