class @Besko.Routers.Registrations extends Support.SwappingRouter

  initialize: ->
    @el = $('div#content')[0]

  routes:
    "accounts/signup" : "newAccount"

  newAccount: ->
    @swap new Besko.Views.SignupForm(collection: new Besko.Collections.Users())
