#= require application

describe "Besko.Views.UserSearch", ->

  beforeEach ->
    @select = (request, respond) ->
    @view = new Besko.Views.UserSearch select: @select
    @view.render()

  it "has a search field to lookup recipients", ->
    expect(@view.$el).toContain('input#user-search[type=search]')

  it "handles autocompleteselect with the select function passed in", ->
    $search = @view.$('#user-search')
    expect($search).toHandle('autocompleteselect')

  it "sets custom source callback for building results list", ->
    callback = @view.$('#user-search').autocomplete('option', 'source')
    expect(callback).toEqual(@view.autocomplete)

  it "creates an empty array to cache users", ->
    expect(@view.users).not.toEqual(undefined)
