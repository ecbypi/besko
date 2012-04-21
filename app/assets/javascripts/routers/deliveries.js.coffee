class @Besko.Routers.Deliveries extends Support.SwappingRouter

  initialize: ->
    @route(/^deliveries(?:\?date=(\d{4}-\d{2}-\d{2}))?$/, 'search')
    @el = document.getElementById('content')
    @collection = Besko.bootstrap(Besko.Collections.Deliveries)

  routes:
    "deliveries/new": "newDelivery"

  search: (date) ->
    @swap new Besko.Views.DeliverySearch(
      collection: @collection
      date: date
    )

  newDelivery: ->
    @swap new Besko.Views.DeliveryForm(model: new Besko.Models.Delivery())
