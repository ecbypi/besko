#= require application

describe "Besko.Views.ReceiptForm", ->
  beforeEach ->
    receipt = new Besko.Models.Receipt(
      recipient:
        id: 1
        first_name: 'Micro'
        last_name: 'Helpline'
        email: 'mrhalp@mit.edu'
        login: 'mrhalp'
    )
    @form = new Besko.Views.ReceiptForm(model: receipt)
    @form.render()

  it "has a number input for number of packages, defaulting to 1", ->
    expect(@form.$el).toContain('input[type=number][value=1][min=1]')

  it "has a textarea for comments", ->
    expect(@form.$el).toContain('textarea')

  it "has the name of the recipient", ->
    expect(@form.$el).toHaveText(/Micro Helpline/)

  it "has a button to remove the form", ->
    $button = @form.$('button[data-cancel]')
    expect($button).toHaveText(/Remove/)

  describe "clicking the Remove button", ->
    beforeEach ->
      @parent = new Support.CompositeView()
      @parent.appendChild(@form)

    it "removes itself form it's parent", ->
      sinon.spy(@parent, '_removeChild')
      sinon.spy(@form, '_removeFromParent')
      @form.$('button[data-cancel]').click()
      expect(@parent._removeChild).toHaveBeenCalledOnce()
      expect(@form._removeFromParent).toHaveBeenCalledOnce()
      expect(@parent.$el).not.toContain('li[data-resource][data-recipient]')

  describe "#commit()", ->
    it "returns an array of error objects if any of them fail", ->
      form = new Besko.Views.ReceiptForm(model: new Besko.Models.Receipt())
      form.render()

      errors = form.commit()

      expect(errors.length).toEqual(1)
      expect(_.isArray(errors)).toBeTruthy()

    it "it returns the attributes of the receipt when it passes", ->
      @form.$('textarea').val('Some text')
      @form.$('input[type=number]').val(3)

      attributes = @form.commit()

      expect(attributes.number_packages).toEqual('3')
      expect(attributes.comment).toEqual('Some text')
