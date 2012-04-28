#= require application

describe "Besko.Support", ->

  describe ".bootstrap(ctor)", ->
    it "takes bootstrapped data and passes it into a constructor", ->
      loadFixtures 'bootstrap'
      model = Besko.Support.bootstrap(Backbone.Model)
      expect(model.constructor).toEqual(Backbone.Model)

  describe ".loadUser(model, name)", ->
    it "takes a model and association name for the user and laods it from data passed in", ->
      model = new Backbone.Model(parent: {id: 1})

      Besko.Support.loadUser(model, 'parent')

      expect(model.parent instanceof Besko.Models.User).toBeTruthy()
      expect(model.get('parent_id')).toEqual(1)

    it "saves user information if unpersisted", ->
      parent = new Besko.Models.User({})
      save = sinon.spy(parent, 'save')

      model = new Backbone.Model(parent: parent)

      Besko.Support.loadUser(model, 'parent')
      expect(save).toHaveBeenCalled()
