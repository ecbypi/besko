#= require application

describe "Besko.Models.Receipt", ->
  beforeEach ->
    @receipt = new Besko.Models.Receipt({})

  it "is persisted at /receipts", ->
    expect(@receipt.url()).toEqual('/receipts')

  it "defaults number of packages to 1", ->
    numberPackages = @receipt.get('number_packages')
    expect(numberPackages).toEqual(1)
