//= require application

describe("Besko.Models.Delivery", function() {
  var delivery;

  beforeEach(function() {
    delivery = new Besko.Models.Delivery({
      worker: {
        first_name: 'Micro',
        last_name: 'Helpline'
      }
    });
  });

  it("is persisted and loaded from /deliveries", function() {
    expect(delivery.url()).toEqual('/deliveries');
  });

  it("has a collection of receipts", function() {
    expect(delivery.receipts.constructor).toEqual(Besko.Collections.Receipts);
  });

  describe("#toJSON()", function() {
    var json, receipts;

    beforeEach(function() {
      delivery.receipts.add({recipient_id: 1, number_packages: 1, comment: 'Fragile'});
      json = delivery.toJSON();
      receipts = json.delivery.receipts_attributes;
    });

    it("customizes json to include delivery object in the root json", function() {
      expect(json.delivery).not.toBeUndefined();
    });

    it("includes receipts_attributes", function() {
      expect(receipts).toEqual([{recipient_id: 1, number_packages: 1, comment: 'Fragile'}]);
    });
  });
});
