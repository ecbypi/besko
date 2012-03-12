#= require application

describe "Besko.Collections.Deliveries", ->

  it "is persisted at /deliveries", ->
    collection = new Besko.Collections.Deliveries()
    expect(collection.url).toEqual '/deliveries'

  it "has instances of delivery", ->
    collection = new Besko.Collections.Deliveries()
    expect(collection.model).toEqual Besko.Models.Delivery
