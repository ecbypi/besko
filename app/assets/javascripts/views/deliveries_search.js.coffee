class @Besko.Views.DeliveriesSearch extends Support.CompositeView

  initialize: (attributes) ->
    @date = if attributes.date then new Date(attributes.date) else new Date()
    _.extend(@date, DateExtensions)
    _.bindAll(this, 'render')
    @collection.bind 'reset', @render

  events:
    'click button.next' : 'next'
    'click button.prev' : 'prev'

  render: ->
    @_leaveChildren()
    html = window.JST['deliveries/search'](date: @date)
    this.$el.html(html)
    @renderDeliveries()
    this

  renderDeliveries: ->
    $tbody = this.$('tbody')
    @collection.each (delivery) =>
      child = new Besko.Views.DeliveriesTableRow(model: delivery)
      @renderChild(child)
      $tbody.append child.el
    this

  next: ->
    @fetch @date.increment()

  prev: ->
    @fetch @date.decrement()

  fetch: (date) ->
    @date = date
    iso = @date.toISODateString()
    @collection.fetch
      data:
        date: iso
      success: (users, resposne) ->
        window.history.replaceState({}, "Deliveries - #{iso}", '/deliveries?date=' + iso)
