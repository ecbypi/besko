//= require application

describe("Besko.Collections.Users", function() {
  var collection = new Besko.Collections.Users();

  it("collects users", function() {
    expect(collection.model).toEqual(Besko.Models.User);
  });

  it("reads and writes to /users", function() {
    expect(collection.url).toEqual('/users');
  });
});
