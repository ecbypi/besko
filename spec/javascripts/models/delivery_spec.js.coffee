#= require application

describe "Besko.Models.Delivery", ->
  beforeEach ->
    @delivery = new Besko.Models.Delivery()

  it "is persited and loaded from /deliveries", ->
    expect(@delivery.url()).toEqual '/deliveries'
    @delivery.set('id', 1)
    expect(@delivery.url()).toEqual '/deliveries/1'

  it "defaults receipts_attributes to empty array", ->
    expect(@delivery.get('receipts_attributes')).toEqual([])
