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
