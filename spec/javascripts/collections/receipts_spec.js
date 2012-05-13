//= require application

describe("Besko.Collections.Receipts", function() {
  var collection = new Besko.Collections.Receipts();

  it("is persisted at /receipts", function() {
    expect(collection.url).toEqual('/receipts');
  });

  it("is a collection of Receipt models", function() {
    expect(collection.model).toEqual(Besko.Models.Receipt);
  });
});
