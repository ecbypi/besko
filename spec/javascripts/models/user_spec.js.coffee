#= require application

describe "Besko.Models.User", ->

  it "has a method for the full name", ->
    user = new Besko.Models.User first_name: 'Micro', last_name: 'Helpline'
    expect(user.name()).toEqual 'Micro Helpline'
