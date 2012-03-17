class @Besko.Models.Delivery extends Backbone.Model

  initialize: (attributes) ->
    @worker = new Besko.Models.User(attributes.worker) if attributes && attributes.worker

  urlRoot: '/deliveries'

  defaults:
    receipts_attributes: []

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
