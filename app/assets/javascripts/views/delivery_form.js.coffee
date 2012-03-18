class @Besko.Views.DeliveryForm extends Support.CompositeView

  tagName: 'section'
  attributes:
    'data-resource': 'delivery'

  events:
    'click button[data-role=commit]' : 'submit'
    'click button[data-role=cancel]' : 'reset'

  render: ->
    @form = new Backbone.Form model: @model
    this.$el.append(@form.render().el)

    this.$el.append(window.JST['deliveries/form'])

    this.$('#user-search').autocomplete(
      source: '/users?autocomplete=true'
      select: (event, ui) =>
        delete ui.item.value
        delete ui.item.label
        @renderReceipt(ui.item)
      minLength: 3
    )
    this

  renderReceipt: (recipient) ->
    child = new Besko.Views.ReceiptForm(
      model: new Besko.Models.Receipt(recipient: recipient))
    @renderChild(child)
    this.$('ul[data-collection=receipts]').append(child.el)
    this

  submit: ->
    receipts_attributes = []
    @children.each (child) -> receipts_attributes.push(child.form.getValue())
    @form.commit()
    @model.save(receipts_attributes: receipts_attributes)
    @reset()
    Notification.notice 'Notifications Sent'

  reset: ->
    @children.each (child) -> child.leave()
    this.$('select').val('')
    this
