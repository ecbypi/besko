#= require application

describe "Besko.Models.Receipt", ->

  beforeEach ->
    @receipt = new Besko.Models.Receipt(recipient: { id: 1 })

  it "defaults number of packages to 1", ->
    numberPackages = @receipt.get('number_packages')
    expect(numberPackages).toEqual(1)
