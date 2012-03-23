#= require application

describe "Besko.Models.Delivery", ->
  beforeEach ->
    @delivery = new Besko.Models.Delivery(
      worker:
        first_name: 'Micro'
        last_name: 'Helpline'
    )

  it "is persited and loaded from /deliveries", ->
    expect(@delivery.url()).toEqual '/deliveries'
    @delivery.set('id', 1)
    expect(@delivery.url()).toEqual '/deliveries/1'

  it "initializes a user model if worker attributes are passed in during initialization", ->
    worker = @delivery.worker
    expect(worker.constructor).toEqual(Besko.Models.User)

  it "has a collection of receipts", ->
    expect(@delivery.receipts.constructor).toEqual(Besko.Collections.Receipts)

  it "sets #worker to a user model if one is passed in during initialization", ->
    delivery = new Besko.Models.Delivery(
      worker: new Besko.Models.User
    )
    worker = delivery.worker
    expect(worker.constructor).toEqual(Besko.Models.User)

  describe "#toJSON()", ->
    beforeEach ->
      @delivery.receipts.add({recipient_id: 1, number_packages: 1, comment: 'Fragile'})
      @json = @delivery.toJSON()

    it "customizes json to include delivery object in the root json", ->
      expect(@json.delivery).not.toBeUndefined()

    it "includes receipts_attributes", ->
      receipts = @json.delivery.receipts_attributes
      expect(receipts).toEqual([{recipient_id: 1, number_packages: 1, comment: 'Fragile'}])
