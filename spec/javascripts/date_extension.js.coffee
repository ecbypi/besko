#= require date_extensions

describe "DateExtensions", ->
  beforeEach ->
    @date = new Date('2010-10-30')
    _.extend(@date, DateExtensions)

  it "adds a method to get the name of the UTC day", ->
    expect(@date.getUTCDayName()).toEqual('Saturday')

  it "adds a method to get the name of the UTCH month", ->
    expect(@date.getUTCMonthName()).toEqual('October')
