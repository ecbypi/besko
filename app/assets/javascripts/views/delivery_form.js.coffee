class @Besko.Views.DeliveryForm extends Support.CompositeView

  initialize: ->
    @model ||= new Besko.Models.Delivery()
    @users = new Besko.Collections.Users()

  tagName: 'section'
  attributes:
    'data-resource': 'delivery'

  events:
    'click button[data-role=commit]' : 'submit'
    'click button[data-role=cancel]' : 'reset'

  render: ->
    @form = new Backbone.Form model: @model, schema: @schema
    this.$el.append @form.render().el
    this.$el.append window.JST['deliveries/form']
    this.$('#user-search').autocomplete(
      source: @searchForRecipient
      select: @selectRecipient
      minLength: 3
    )
    this

  searchForRecipient: (request, callback) =>
    request.search_ldap = true
    @users.fetch
      data: request
      success: (users, status, xhr) ->
        callback users.autocompleteResults()

  selectRecipient: (event, ui) =>
    recipient = @users.find (user) -> user.get('login') is ui.item.value
    @addRecipient recipient
    this.$('#user-search').val('')
    false

  addRecipient: (recipient) ->
    recipient.save() unless recipient.id?
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

  schema:
    deliverer:
      title: 'Delivery Company'
      type: 'Select'
      validators: ['required']
      options: [
        { val: '', label: '' }
        { val: 'UPS', label: 'UPS' },
        { val: 'USPS', label: 'USPS' },
        { val: 'FedEx', label: 'FedEx' },
        { val: 'LaserShip', label: 'LaserShip' },
        { val: 'Other', label: 'Other' }
      ]
      editorClass: 'select input required'
      fieldClass: 'select required'
      help: 'usually on package label'
