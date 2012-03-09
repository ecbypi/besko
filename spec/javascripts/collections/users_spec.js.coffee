#= require application

describe "Besko.Collections.Users", ->

  it "collects users", ->
    collection = new Besko.Collections.Users()
    expect(collection.model).toEqual Besko.Models.User

  it "reads and writes to /users", ->
    collection = new Besko.Collections.Users()
    expect(collection.url).toEqual '/users'

  describe "#autocompleteResults", ->

    it "maps user models to objects with label/value keys", ->
      user = new Besko.Models.User(
        id: 1
        login: 'mrhalp'
        email: 'mrhalp@mit.edu'
        first_name: 'Micro'
        last_name: 'Helpline'
      )
      users = new Besko.Collections.Users [user]
      results = users.autocompleteResults()
      expect(results).toEqual([{ label: 'Micro Helpline', value: 'mrhalp'}])
