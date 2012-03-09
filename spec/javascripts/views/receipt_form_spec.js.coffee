#= require application

describe "Besko.Views.ReceiptForm", ->

  beforeEach ->
    user = new Besko.Models.User(
      id: 1
      first_name: 'Micro'
      last_name: 'Helpline'
    )
    receipt = new Besko.Models.Receipt recipient: user
    @form = new Besko.Views.ReceiptForm model: receipt
    @form.render()

  it "has the attribute [data-recipient] with value pointing to the recipient's name", ->
    expect(@form.$el).toBe('[data-recipient="Micro Helpline"]')

  it "has a number input for number of packages, defaulting to 1", ->
    expect(@form.$el).toContain('input[type=number][value=1][min=1]')

  it "has a textarea for comments", ->
    expect(@form.$el).toContain('textarea')

  it "has a hidden input for the recipient (user) id", ->
    expect(@form.$el).toContain('input[type=hidden][value=1]')

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
