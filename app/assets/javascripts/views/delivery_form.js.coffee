class @Besko.Views.DeliveryForm extends Support.CompositeView

  initialize: ->
    @model ||= new Besko.Models.Delivery()

  tagName: 'section'
  attributes:
    'data-resource': 'delivery'

  render: ->
    form = new Backbone.Form model: @model, schema: @schema
    this.$el.append form.render().el

    @search = new Besko.Views.UserSearch select: @selectRecipient
    @search.render()
    this.$el.append @search.el

    this.$el.append window.JST['deliveries/form']
    this

  selectRecipient: (elem, ui) =>
    recipient = @search.users.find (user) -> user.get('login') is ui.item.value
    @addReceipt recipient

  addReceipt: (recipient) ->
    receipt = new Besko.Models.Receipt recipient: recipient
    child = new Besko.Views.ReceiptForm model: receipt
    @renderChild(child)
    this.$('ul[data-collection=receipts]').append child.el
    this

  schema:
    deliverer:
      title: 'Delivery Company'
      type: 'Select'
      options: [
        { val: 'UPS', label: 'UPS' },
        { val: 'USPS', label: 'USPS' },
        { val: 'FedEx', label: 'FedEx' },
        { val: 'LaserShip', label: 'LaserShip' },
        { val: 'Other', label: 'Other' }
      ]
      editorClass: 'select input required'
      fieldClass: 'select required'
      help: 'usually on package label'
