#= require application

describe "Besko.Views.SignupForm", ->
  beforeEach ->
    @view = new Besko.Views.SignupForm()
    @view.render()

  it "has a search input", ->
    expect(@view.$el).toContain('input[type=search]')
    expect(@view.$el).toContain('button[data-role=search]')

  it "has an empty div for search results", ->
    expect(@view.$el).toContain('table[data-collection=users]')
