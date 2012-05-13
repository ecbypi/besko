//= require application

describe("Besko.Date()", function() {
  var date = Besko.Date('2010-10-30'), nextDay, prevDay;

  it("adds a method to get the name of the UTC day", function() {
    expect(date.getUTCDayName()).toEqual('Saturday');
  });

  it("adds a method to get the name of the UTCH month", function() {
    expect(date.getUTCMonthName()).toEqual('October');
  });

  describe("#increment", function() {
    it("increases day by one by default", function() {
      expect(date.increment().getUTCDate()).toEqual(31);
    });

    it("increases day by number passed in", function() {
      nextDay = date.increment(2);
      expect(nextDay.getUTCDate()).toEqual(1);
      expect(nextDay.getUTCMonth()).toEqual(10);
    });
  });

  describe("#decrement", function() {
    it("descreases day by one by default", function() {
      expect(date.decrement().getUTCDate()).toEqual(29);
    });

    it("decreases date by amount passed in", function() {
      prevDay = date.decrement(2);
      expect(prevDay.getUTCDate()).toEqual(28);
    });
  });

  describe("#strftime", function() {
    it("allows custom formatting of strings", function() {
      expect(date.strftime('%A, %B %D, %Y %H:%M:%S')).toEqual('Saturday, October 30, 2010 00:00:00');
    });
  });
});
