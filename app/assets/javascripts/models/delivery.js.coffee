class @Besko.Models.Delivery extends Backbone.Model

  urlRoot: '/deliveries'

  defaults:
    receipts_attributes: []
  initialize: (attributes) ->
    attributes ||= {}
    @loadWorker(attributes.worker)

  loadWorker: (worker) ->
    if worker
      if worker.constructor == Besko.Models.User
        @worker = worker
      else if _.isObject(worker)
        @worker = new Besko.Models.User(worker)

  toJSON: ->
    attributes = _.clone(@attributes)
    attributes.receipts_attributes = @get('receipts_attributes')
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
