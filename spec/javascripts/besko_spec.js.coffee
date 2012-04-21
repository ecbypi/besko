#= require application

describe "Besko", ->

  beforeEach ->
    loadFixtures 'bootstrap'

  describe ".bootstrap()", ->
    it "takes bootstrapped data and passes it into a constructor", ->
      model = Besko.bootstrap(Backbone.Model)
      expect(model.constructor).toEqual(Backbone.Model)
