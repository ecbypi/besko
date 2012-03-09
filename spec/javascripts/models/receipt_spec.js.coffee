#= require application

describe "Besko.Models.Receipt", ->

  beforeEach ->
    user = new Besko.Models.User id: 1
    @receipt = new Besko.Models.Receipt recipient: user

  it "pulls out id of user as recipient_id", ->
    expect(@receipt.get('recipient_id')).toEqual(1)

  it "defaults number of packages to 1", ->
    numberPackages = @receipt.get('number_packages')
    expect(numberPackages).toEqual(1)
