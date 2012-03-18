class @Besko.Views.ReceiptForm extends Support.CompositeView

  tagName: 'li'
  attributes:
    'data-resource': 'receipt'

  events:
    'click button[data-cancel]': 'leave'

  schema:
    number_packages:
      title: 'Number of Packages'
      dataType: 'number'
      editorClass: 'input number required'
      fieldClass: 'number required'
      editorAttrs:
        min: 1
    comment:
      title: 'Comment'
      type: 'TextArea'
      editorClass: 'input text optional'
      fieldClass: 'text optional'
    recipient_id:
      editorAttrs:
        type: 'hidden'
      title: ' '
      editorClass: 'input hidden required'
      fieldClass: 'hidden required'

  render: ->
    @form = new Backbone.Form schema: @schema, model: @model
    this.$el.attr('data-recipient', @model.get('recipient').name())
    this.$el.html window.JST['receipts/form'] recipient: @model.get('recipient')
    this.$('span').after @form.render().el
    this
