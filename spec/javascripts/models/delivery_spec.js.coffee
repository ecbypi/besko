#= require application

describe "Besko.Models.Delivery", ->

  it "is persited and loaded from /deliveries", ->
    delivery = new Besko.Models.Delivery()
    expect(delivery.url()).toEqual '/deliveries'
    delivery.set('id', 1)
    expect(delivery.url()).toEqual '/deliveries/1'
