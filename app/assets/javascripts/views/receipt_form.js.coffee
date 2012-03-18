class @Besko.Views.ReceiptForm extends Support.CompositeView

  tagName: 'li'
  attributes:
    'data-resource': 'receipt'

  events:
    'click button[data-cancel]': 'leave'

  render: ->
    @form = new Backbone.Form schema: @schema, model: @model
    this.$el.attr('data-recipient', @model.get('recipient').name())
    this.$el.html window.JST['receipts/form'] recipient: @model.get('recipient')
    this.$('span').after @form.render().el
    this
