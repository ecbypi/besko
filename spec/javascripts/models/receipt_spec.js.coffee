#= require application

describe "Besko.Models.Receipt", ->

  it "pulls out id of user as recipient_id", ->
    user = new Besko.Models.User id: 1
    receipt = new Besko.Models.Receipt recipient: user
    expect(receipt.get('recipient_id')).toEqual(1)

  it "defaults number of packages to 1", ->
    numberPackages = new Besko.Models.Receipt().get('number_packages')
    expect(numberPackages).toEqual(1)
