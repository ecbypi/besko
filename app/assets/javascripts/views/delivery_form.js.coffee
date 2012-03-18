class @Besko.Views.DeliveryForm extends Support.CompositeView

  tagName: 'section'
  attributes:
    'data-resource': 'delivery'

  events:
    'click button[data-role=commit]' : 'submit'
    'click button[data-role=cancel]' : 'reset'

  render: ->
    @form = new Backbone.Form model: @model
    this.$el.append @form.render().el
    this.$el.append window.JST['deliveries/form']
    this.$('#user-search').autocomplete(
      source: '/users?autocomplete=true'
      select: (event, ui) =>
        delete ui.item.value
        delete ui.item.label
        @addRecipient ui.item
      minLength: 3
    )
    this

  addRecipient: (recipient) ->
    child = new Besko.Views.ReceiptForm(
      model: new Besko.Models.Receipt(
        recipient: recipient
      )
    )
    @renderChild(child)
    this.$('ul[data-collection=receipts]').append child.el
    this

  submit: ->
    receipts_attributes = []
    @children.map (child) -> receipts_attributes.push child.form.getValue()
    @form.commit()
    @model.save receipts_attributes: receipts_attributes
    @reset()
    Notification.notice 'Notifications Sent'

  reset: ->
    @children.map (child) -> child.leave()
    this.$('select').val('')
    this
