#= require application

describe "Besko.Views.DeliveriesSearch", ->
  beforeEach ->
    @view = new Besko.Views.DeliveriesSearch(
      collection: new Besko.Collections.Deliveries()
      date: '2010-10-30'
    )
    @view.render()

  it "has buttons for next and previous day", ->
    expect(@view.$el).toContain('button.next')
    expect(@view.$el).toContain('button.prev')

  it "has an <h2> tag for showing what day we're on", ->
    expect(@view.$el).toContain('h2')
    expect(@view.$el).toHaveText(/Saturday, October 30, 2010/)

  it "tracks the current date", ->
    expect(@view.date.getUTCFullYear()).toEqual(2010)
    expect(@view.date.getUTCMonth()).toEqual(9)
    expect(@view.date.getUTCDate()).toEqual(30)
