class @Besko.Models.User extends Backbone.Model

  urlRoot: '/users'

  name: ->
    "#{@get('first_name')} #{@get('last_name')}"

  schema:
    id: {}
    first_name: {}
    last_name: {}
    email: {}
    login: {}

