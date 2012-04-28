#= require application

describe "Besko.Collections.Users", ->

  it "collects users", ->
    collection = new Besko.Collections.Users()
    expect(collection.model).toEqual Besko.Models.User

  it "reads and writes to /users", ->
    collection = new Besko.Collections.Users()
    expect(collection.url).toEqual '/users'
