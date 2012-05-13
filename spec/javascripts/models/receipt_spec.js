//= require application

describe("Besko.Models.Receipt", function() {
  var receipt, numberPackages;

  beforeEach(function() {
    receipt = new Besko.Models.Receipt({});
  });

  it("is persisted at /receipts", function() {
    expect(receipt.url()).toEqual('/receipts');
  });

  it("defaults number of packages to 1", function() {
    numberPackages = receipt.get('number_packages');
    expect(numberPackages).toEqual(1);
  });
});
