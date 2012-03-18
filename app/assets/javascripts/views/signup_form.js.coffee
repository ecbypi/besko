class @Besko.Views.SignupForm extends Support.CompositeView

  initialize: ->
    @users = new Besko.Collections.Users()

  events:
    'click button[data-role=search]' : 'search'
    'click button[data-role=commit]' : 'reset'

  render: ->
    this.$el.html window.JST['registrations/search']
    this

  search: ->
    @users.fetch
      data:
        term: this.$('#user-search').val()
      success: (users, request, xhr) =>
        unless @users.models.length is 0
          @renderUsers()
        else
          Notification.error 'Your search did not return any results.'
      error: (users, request, xhr) ->
        Notification.error 'Error processing your request.'

  renderUsers: =>
    $users = this.$('table').
      html(window.JST['registrations/results']).
      find('tbody')
    @users.each (user) =>
      child = new Besko.Views.SignupSearchResult model: user
      @renderChild child
      $users.append child.el
    this

  reset: ->
    @children.each (child) -> child.leave()
    this.$('table').html ''
    Notification.notice 'Your account has been submitted for approval'
    this.$('#user-search').val ''