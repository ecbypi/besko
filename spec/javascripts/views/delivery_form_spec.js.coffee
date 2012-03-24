#= require application

describe "Besko.Views.DeliveryForm", ->
  beforeEach ->
    @form = new Besko.Views.DeliveryForm(
      model: new Besko.Models.Delivery()
    )
    @form.render()
    @recipient =
      id: 1
      first_name: 'Micro'
      last_name: 'Helpline'
      login: 'mrhalp'
      email: 'mrhalp@mit.edu'

  it "has the class 'new-delivery'", ->
    expect(@form.$el).toBe('.new-delivery')

  describe "it contains a(n)", ->
    it "empty table of receipts", ->
      expect(@form.$el).toContain('table[data-collection=receipts]')

    it "search field to lookup recipients", ->
      expect(@form.$el).toContain('input[type=search]')

    it "select field for delivery company", ->
      expect(@form.$el).toContain('select[name=deliverer]')

    it "select with delivery company options for FedEx, USPS, UPS, LaserShip and Other", ->
      expect(@form.$el).toContain('option[value=""]')
      expect(@form.$el).toContain('option[value=FedEx]')
      expect(@form.$el).toContain('option[value=USPS]')
      expect(@form.$el).toContain('option[value=UPS]')
      expect(@form.$el).toContain('option[value=LaserShip]')
      expect(@form.$el).toContain('option[value=Other]')

    it "button to send all notifications", ->
      expect(@form.$el).toContain('button[data-role=commit]')

    it "button to cancel all receipts", ->
      expect(@form.$el).toContain('button[data-role=cancel]')


  describe "can support an 'Other' deliverer", ->
    it "by switching out the select with a text field", ->
      @form.$('select').val('Other')
      @form.$('select').trigger('change')
      expect(@form.$el).toContain('input#deliverer[type=text]')
      expect(@form.$('input#deliverer')).toHaveAttr('autofocus')

  describe "#renderReceipt", ->
    beforeEach ->
      @form.renderReceipt(@recipient)

    it "adds a ReceiptForm to unordered list", ->
      $tbody = @form.$el.find('tbody')
      expect($tbody).toContain('tr')
      expect($tbody.children().length).toEqual(1)

    it "adds instances of ReceiptForm to #children", ->
      expect(@form.children.size()).toEqual(1)

    it "alerts if someone is added twice", ->
      sinon.spy(Notification, 'error')
      @form.renderReceipt(@recipient)
      expect(Notification.error).toHaveBeenCalled()
      expect(@form.$('tbody').children().length).toEqual(1)

  describe "#commit()", ->
    describe "when in an invalid state", ->
      it "returns false", ->
        output = @form.commit()
        expect(output).toEqual(false)
