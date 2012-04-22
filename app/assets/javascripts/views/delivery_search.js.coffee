class @Besko.Views.DeliverySearch extends Support.CompositeView

  className: 'deliveries'

  initialize: (options) ->
    @date = Besko.Date(options.date)
    _.bindAll(this, 'renderDeliveries')
    @collection.bind('reset', @renderDeliveries)

  events:
    'click button.next' : 'next'
    'click button.prev' : 'prev'

  render: ->
    this.$el.html(window.JST['deliveries/search'](date: @date))
    @initializeDatePicker()
    @renderDeliveries()
    this

  initializeDatePicker: ->
    @datepicker = this.$('input[name=delivered_on]').datepicker(
      minDate: 'Tuesday, October 19, 2010'
      maxDate: Besko.Date().strftime('%A, %B %D, %Y')
      dateFormat: 'DD, MM dd, yy'
      changeMonth: true
      changeYear: true
      selectOtherMonths: true
      showOtherMonths: true
      onSelect: (dateText, options) =>
        @fetch Besko.Date(dateText)
      buttonText: 'Change'
      showOn: 'button'
      autoSize: true
      hideIfNoPrevNext: true
    ).val(@date.strftime('%A, %B %D, %Y'))

  renderDeliveries: ->
    @_leaveChildren()
    $tbody = this.$('tbody')
    @collection.each (delivery) =>
      child = new Besko.Views.DeliveryRow(model: delivery)
      @renderChild(child)
      $tbody.append child.el
    this

  next: ->
    @fetch @date.increment()

  prev: ->
    @fetch @date.decrement()

  fetch: (date) ->
    @date = date
    @datepicker.val(@date.strftime('%A, %B %D, %Y'))
    iso = @date.strftime('%Y-%m-%D')
    @collection.fetch
      data:
        date: iso
      success: (deliveries, resposne) =>
        window.history.replaceState({}, "Deliveries - #{iso}", '/deliveries?date=' + iso)
