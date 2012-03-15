#= require date_extensions

describe "DateExtensions", ->
  beforeEach ->
    @date = new Date('2010-10-30')
    _.extend(@date, DateExtensions)

  it "adds a method to get the name of the UTC day", ->
    expect(@date.getUTCDayName()).toEqual('Saturday')

  it "adds a method to get the name of the UTCH month", ->
    expect(@date.getUTCMonthName()).toEqual('October')

  describe "#increment", ->
    it "increases day by one by default", ->
      expect(@date.increment().getUTCDate()).toEqual(31)

    it "increases day by number passed in", ->
      date = @date.increment(2)
      expect(date.getUTCDate()).toEqual(1)
      expect(date.getUTCMonth()).toEqual(10)

  describe "#decrement", ->
    it "descreases day by one by default", ->
      expect(@date.decrement().getUTCDate()).toEqual(29)

    it "decreases date by amount passed in", ->
      date = @date.decrement(2)
      expect(date.getUTCDate()).toEqual(28)

  describe "#toISODateString", ->
    it "returns #toISOString but without time", ->
      expect(@date.toISODateString()).toEqual('2010-10-30')
