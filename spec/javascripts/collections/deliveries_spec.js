//= require application

describe("Besko.Collections.Deliveries", function() {
  var collection = new Besko.Collections.Deliveries();

  it("is persisted at /deliveries", function() {
    expect(collection.url).toEqual('/deliveries');
  });

  it("has instances of delivery", function() {
    expect(collection.model).toEqual(Besko.Models.Delivery);
  });
});
