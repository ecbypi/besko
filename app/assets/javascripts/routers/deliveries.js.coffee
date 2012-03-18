class @Besko.Routers.Deliveries extends Support.SwappingRouter

  initialize: ->
    @route(/^deliveries(?:\?date=(\d{4}-\d{2}-\d{2}))?$/, 'search')
    @el = document.getElementById('content')
    if (data = $('#deliveries')).length > 0
      @collection = Besko.parse(data.text(), Besko.Collections.Deliveries)

  routes:
    "deliveries/new": "newDelivery"

  search: (date) ->
    @swap new Besko.Views.DeliverySearch(
      collection: @collection
      date: date
    )

  newDelivery: ->
    @swap new Besko.Views.DeliveryForm(model: new Besko.Models.Delivery())
