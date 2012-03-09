class @Besko.Views.UserSearch extends Support.CompositeView

  initialize: (options) ->
    @select = options.select
    @users = new Besko.Collections.Users()
    this

  render: ->
    this.$el.html window.JST['users/search']
    this.$search = this.$('#user-search').autocomplete(
      source: @autocomplete
      minLength: 3
    )
    this.$search.bind('autocompleteselect', @select) if @select?
    this

  autocomplete: (request, callback) =>
    @users.fetch
      data: request
      success: (users, status, xhr) ->
        callback users.autocompleteResults()
