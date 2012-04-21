#= require application

describe "Besko", ->

  beforeEach ->
    loadFixtures 'bootstrap'

  describe ".bootstrap()", ->
    it "takes bootstrapped data and passes it into a constructor", ->
      model = Besko.bootstrap(Backbone.Model)
      expect(model.constructor).toEqual(Backbone.Model)

  describe ".extendDate()", ->
    it "takes a date object and extends it with DateExtensions", ->
      date = new Date('2010-10-30')
      extendedDate = Besko.extendDate(date)
      expect(extendedDate.getUTCMonthName()).toEqual('October')
