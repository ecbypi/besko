class @Besko.Models.Delivery extends Backbone.Model

  urlRoot: '/deliveries'

  initialize: (attributes) ->
    attributes ||= {}
    @loadWorker(attributes.worker)
    @receipts = new Besko.Collections.Receipts(attributes.receipts)

  loadWorker: (worker) ->
    if worker
      if worker.constructor == Besko.Models.User
        @worker = worker
      else if _.isObject(worker)
        @worker = new Besko.Models.User(worker)

  toJSON: ->
    receipts = { receipts_attributes: @receipts.toJSON() }
    attributes = _.extend(super(), receipts)
    { delivery: attributes }

  schema:
    deliverer:
      title: 'Delivery Company'
      type: 'Select'
      validators: ['required']
      options: [
        { val: '', label: '' }
        { val: 'UPS', label: 'UPS' },
        { val: 'USPS', label: 'USPS' },
        { val: 'FedEx', label: 'FedEx' },
        { val: 'LaserShip', label: 'LaserShip' },
        { val: 'Other', label: 'Other' }
      ]
      editorClass: 'select input required'
      fieldClass: 'select required'
      help: 'usually on package label'
