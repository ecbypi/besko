class @Besko.Routers.Deliveries extends Support.SwappingRouter

  initialize: ->
    @el = $('div#content')[0]

  routes:
    "deliveries/new": "newDelivery"

  newDelivery: ->
    @swap new Besko.Views.DeliveryForm()
