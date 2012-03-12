#= require application

describe "Besko.Views.DeliveryForm", ->
  beforeEach ->
    @recipient = new Besko.Models.User(
      id: 1
      first_name: 'Micro'
      last_name: 'Helpline'
      email: 'mrhalp@mit.edu'
      login: 'mrhalp'
    )
    @form = new Besko.Views.DeliveryForm()
    @form.render()

  it "initializes a delivery instance one isn't passed in", ->
    expect(@form.model).not.toEqual(undefined)

  it "is a section", ->
    expect(@form.$el).toBe('section')
    expect(@form.$el).toHaveAttr('data-resource', 'delivery')

  describe "it contains a(n)", ->
    it "empty unordered list of receipts", ->
      expect(@form.$el).toContain('ul[data-collection=receipts]')

    it "search field to lookup recipients", ->
      expect(@form.$el).toContain('input[type=search]')

    it "select field for delivery company", ->
      expect(@form.$el).toContain('select[name=deliverer]')

    it "select with delivery company options for FedEx, USPS, UPS, LaserShip and Other", ->
      expect(@form.$el).toContain('option[value=FedEx]')
      expect(@form.$el).toContain('option[value=USPS]')
      expect(@form.$el).toContain('option[value=UPS]')
      expect(@form.$el).toContain('option[value=LaserShip]')
      expect(@form.$el).toContain('option[value=Other]')

    it "button to send all notifications", ->
      expect(@form.$el).toContain('button[data-role=commit]')

    it "button to cancel all receipts", ->
      expect(@form.$el).toContain('button[data-role=cancel]')

  describe "#addReceipt", ->
    beforeEach ->
      @form.addReceipt(@recipient)

    it "adds a ReceiptForm to unordered list", ->
      $list = @form.$el.find('ul[data-collection=receipts]')
      expect($list).toContain('li')
      expect($list.children().length).toEqual(1)

    it "stores instances of ReceiptForm", ->
      expect(@form.children.size()).toEqual(1)

  describe "#submit", ->
    beforeEach ->
      sinon.spy(@form, 'reset')
      sinon.spy(@form.model, 'save')
      @form.addReceipt(@recipient)
      @form.$('button[data-role=commit]').click()

    it "calls #reset", ->
      expect(@form.reset).toHaveBeenCalled()

    it "saves the delivery", ->
      expect(@form.model.save).toHaveBeenCalled()

    it "adds attributes from receipt forms into delivery#receipts_attributes", ->
      attributes = @form.model.get('receipts_attributes')
      expect(attributes.length).toEqual(1)

  describe "#reset", ->
    beforeEach ->
      @form.addReceipt(@recipient)
      @form.$('button[data-role=cancel]').click()

    it "removes all children", ->
      expect(@form.children.size()).toEqual(0)

    it "removes all receipt forms", ->
      $list = @form.$('ul[data-collection=receipts]')
      expect($list.children().length).toEqual(0)

    it "resets select", ->
      $select = @form.$('select[name=deliverer]')
      expect($select.val()).toEqual('')
