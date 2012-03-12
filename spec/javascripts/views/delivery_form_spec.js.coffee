#= require application

describe "Besko.Views.DeliveryForm", ->

  beforeEach ->
    @form = new Besko.Views.DeliveryForm()
    @form.render()

  it "initializes a delivery instance one isn't passed in", ->
    expect(@form.model).not.toEqual(undefined)

  it "is a section", ->
    expect(@form.$el).toBe('section')
    expect(@form.$el).toHaveAttr('data-resource', 'delivery')

  it "has an empty unordered list of receipts", ->
    expect(@form.$el).toContain('ul[data-collection=receipts]')

  it "has a search field to lookup recipients", ->
    expect(@form.$el).toContain('input[type=search]')

  it "has a select field for delivery company", ->
    expect(@form.$el).toContain('select[name=deliverer]')

  it "has delivery company options for FedEx, USPS, UPS, LaserShip and Other", ->
    expect(@form.$el).toContain('option[value=FedEx]')
    expect(@form.$el).toContain('option[value=USPS]')
    expect(@form.$el).toContain('option[value=UPS]')
    expect(@form.$el).toContain('option[value=LaserShip]')
    expect(@form.$el).toContain('option[value=Other]')

  describe "#addReceipt", ->

    beforeEach ->
      recipient = new Besko.Models.User(
        id: 1
        first_name: 'Micro'
        last_name: 'Helpline'
        email: 'mrhalp@mit.edu'
        login: 'mrhalp'
      )
      @form.addReceipt(recipient)

    it "adds a ReceiptForm to unordered list", ->
      $list = @form.$el.find('ul[data-collection=receipts]')
      expect($list).toContain('li')
      expect($list.children().length).toEqual(1)

    it "stores instances of ReceiptForm", ->
      expect(@form.children.size()).toEqual(1)
