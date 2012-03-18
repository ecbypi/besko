class @Besko.Views.DeliveryRow extends Support.CompositeView

  tagName: 'tr'
  attributes:
    'data-resource': 'delivery'

  render: ->
    html = window.JST['deliveries/table_row'](delivery: @model)
    this.$el.html(html)
    this
