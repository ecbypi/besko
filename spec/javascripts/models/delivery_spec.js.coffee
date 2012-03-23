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

  it "defaults receipts_attributes to empty array", ->
    expect(@delivery.get('receipts_attributes')).toEqual([])

  it "sets #worker to a user model if one is passed in during initialization", ->
    delivery = new Besko.Models.Delivery(
      worker: new Besko.Models.User
    )
    worker = delivery.worker
    expect(worker.constructor).toEqual(Besko.Models.User)

  describe "#toJSON()", ->
    beforeEach ->
      @delivery.set('receipts_attributes', [{recipient_id: 1, number_packages: 1, comment: 'Fragile'}])
      @json = @delivery.toJSON()

    it "customizes json to include delivery object in the root json", ->
      expect(@json.delivery).not.toBeUndefined()

    it "includes receipts_attributes", ->
      expect(@json.delivery.receipts_attributes).toEqual([{recipient_id: 1, number_packages: 1, comment: 'Fragile'}])
