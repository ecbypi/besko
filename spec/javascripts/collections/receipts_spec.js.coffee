#= require application

describe "Besko.Collections.Receipts", ->
  beforeEach ->
    @collection = new Besko.Collections.Receipts()

  it "is persisted at /receipts", ->
    expect(@collection.url).toEqual('/receipts')

  it "is a collection of Receipt models", ->
    expect(@collection.model).toEqual(Besko.Models.Receipt)
