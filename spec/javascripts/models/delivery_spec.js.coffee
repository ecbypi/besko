#= require application

describe "Besko.Models.Delivery", ->
  beforeEach ->
    @delivery = new Besko.Models.Delivery(
      worker:
        first_name: 'Micro'
        last_name: 'Helpline'
    )

  it "is persisted and loaded from /deliveries", ->
    expect(@delivery.url()).toEqual '/deliveries'

  it "has a collection of receipts", ->
    expect(@delivery.receipts.constructor).toEqual(Besko.Collections.Receipts)

  describe "#toJSON()", ->
    beforeEach ->
      @delivery.receipts.add({recipient_id: 1, number_packages: 1, comment: 'Fragile'})
      @json = @delivery.toJSON()

    it "customizes json to include delivery object in the root json", ->
      expect(@json.delivery).not.toBeUndefined()

    it "includes receipts_attributes", ->
      receipts = @json.delivery.receipts_attributes
      expect(receipts).toEqual([{recipient_id: 1, number_packages: 1, comment: 'Fragile'}])
