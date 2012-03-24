class @Besko.Views.ReceiptForm extends Support.CompositeView

  tagName: 'tr'
  className: 'inputs'
  attributes:
    'data-resource': 'receipt'

  events:
    'click button[data-cancel]': 'leave'

  initialize: (options) ->
    @schema = @model.schema()

  render: ->
    @form = @constructEditors()
    template = window.JST['receipts/receipt_form']
    this.$el.html(template(recipientName: @schema.recipient_id.title))
    this.$('td:nth-child(2)').html(@form.number_packages.el)
    this.$('td:nth-child(3)').html(@form.comment.el)
    this

  constructEditors: ->
    createEditor = Backbone.Form.helpers.createEditor

    form = {}
    _.each @schema, (schema, key) =>
      options =
        key: key
        type: schema.type || 'Text'
        model: @model
        schema: schema
      form[key] = createEditor(options.type, options).render()

    form

  commit: ->
    errors = []
    _.each @form, (editor, key) ->
      errors.push(error) if (error = editor.commit())?

    if _.isEmpty(errors) then @model.attributes else errors
