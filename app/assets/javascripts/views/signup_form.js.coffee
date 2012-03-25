class @Besko.Views.SignupForm extends Support.CompositeView

  tagName: 'section'
  className: 'registration'

  events:
    'click button[data-role=search]' : 'search'
    'keyup input#user-search' : 'submitSearch'
    'click button[data-role=commit]' : 'render'

  render: ->
    @_leaveChildren if @children.size() > 0
    markup = window.JST['registrations/signup_form']()
    this.$el.html(markup)
    this

  submitSearch: (event) ->
    if event.keyCode == 13
      @search()

  search: ->
    @_leaveChildren()
    @collection.fetch
      data:
        term: this.$('#user-search').val()
      success: (users, request, xhr) =>
        unless @collection.models.length is 0
          this.$('thead').show()
          @renderUsers()
        else
          Notification.error 'Your search did not return any results.'
      error: (users, request, xhr) ->
        Notification.error 'Error processing your request.'

  renderUsers: =>
    $users = this.$('tbody')
    @_leaveChildren()
    @collection.each (user) =>
      child = new Besko.Views.SignupSearchResult(model: user)
      @renderChild(child)
      $users.append(child.el)
    this
