class @Besko.Collections.Users extends Backbone.Collection

  url: '/users'
  model: Besko.Models.User

  autocompleteResults: ->
    @models.map (user) -> { label: user.name(), value: user.get('login') }
