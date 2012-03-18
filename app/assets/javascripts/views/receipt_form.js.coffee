class @Besko.Views.ReceiptForm extends Support.CompositeView

  tagName: 'li'
  attributes:
    'data-resource': 'receipt'

  events:
    'click button[data-cancel]': 'leave'

  render: ->
    @form = new Backbone.Form(model: @model)
    this.$el.append @form.render().el
    this.$el.append $('<button>').attr('data-cancel', true).text('Remove')
    this
