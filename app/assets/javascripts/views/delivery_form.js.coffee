class @Besko.Views.DeliveryForm extends Support.CompositeView

  className: 'new-delivery'
  tagName: 'section'
  attributes:
    'data-resource': 'delivery'

  events:
    'click button[data-role=commit]' : 'commit'
    'click button[data-role=cancel]' : 'clear'
    'change select#deliverer' : 'swapDelivererEditor'
    'click button[data-cancel]' : 'hideTableDetails'

  render: ->
    @recipients ||= new Besko.Collections.Users()
    @recipients.reset()

    this.$el.html(window.JST['deliveries/delivery_form']())
    @renderDelivererEditor(@schema)
    this.$('#user-search').autocomplete(
      source: '/users?autocomplete=true'
      select: (event, ui) =>
        delete ui.item.value
        delete ui.item.label
        @renderReceipt(ui.item)
      minLength: 3
    )
    this

  renderDelivererEditor: (schema) ->
    @deliverer = new Backbone.Form.editors[schema.type](
      model: @model
      schema: schema
      key: 'deliverer'
      type: schema.type
      id: 'deliverer'
    ).render()
    this.$input = this.$('div.input.select')
    this.$input.find('label').after(@deliverer.el)
    this

  swapDelivererEditor: (event) ->
    if $(event.target).val() == 'Other'
      schema = _.clone(@schema)
      schema.type = 'Text'
      schema.editorClass = 'input string required'
      schema.editorAttrs =
        autofocus: ''
        placeholder: 'Enter name of deliverer'
      @deliverer.remove()
      @renderDelivererEditor(schema)

  renderReceipt: (recipient) ->
    logins = @recipients.pluck('login')
    if !_.include(logins, recipient.login)
      @recipients.add(recipient)
      child = new Besko.Views.ReceiptForm(
        model: new Besko.Models.Receipt(recipient: recipient)
      )
      this.$('thead, tfoot').show() if @children.size() == 0
      @renderChild(child)
      this.$('tbody').append(child.el)
    else
      Notification.error('Already added that person!')
    this

  hideTableDetails: ->
    this.$('thead, tfoot').hide() if @children.size() == 0

  commit: ->
    if @delivererValid() && @receiptsValid()
      @model.save({},
        success: (model, response) =>
          Notification.notice('Notifications Sent')
          @clear()
        error: (model, response) ->
          Notification.error('There was a problem saving this delivery.')
      )
    else
      return false

  delivererValid: ->
    if (error = @deliverer.commit())?
      this.$input.addClass('field_with_errors')
      this.$input.find('.error').text(error.message)
      return false
    return true

  receiptsValid: ->
    @children.each (child) =>
      attributes = child.commit()
      if _.isArray(attributes)
        return false
      else
        @model.receipts.add(attributes)
    return true

  clear: ->
    @children.each (child) -> child.leave()
    @model = new Besko.Models.Delivery()
    @deliverer.remove()
    @render()

  schema:
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
