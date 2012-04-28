#= require application

describe "Besko.Views.SignupForm", ->
  beforeEach ->
    @view = new Besko.Views.SignupForm(
      collection: new Besko.Collections.Users([
        {
          id: 1
          first_name: 'Micro'
          last_name: 'Helpline'
          name: 'Micro Helpline'
          email: 'mrhalp@mit.edu'
          login: 'mrhalp'
          street: 'N42'
        }
        {
          first_name: 'Micro'
          last_name: 'Helpline'
          name: 'Micro Helpline'
          email: 'mrhalp@mit.edu'
          login: 'mrhalp'
          street: 'N42'
        }
      ])
    )
    @view.render()

  it "has a search input", ->
    expect(@view.$el).toContain('input[type=search]')
    expect(@view.$el).toContain('button[data-role=search]')

  it "has an empty table for search results", ->
    expect(@view.$el).toContain('table[data-collection=users]')
