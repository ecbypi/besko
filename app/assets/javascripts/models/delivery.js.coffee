class @Besko.Models.Delivery extends Backbone.Model

  urlRoot: '/deliveries'

  defaults:
    receipts_attributes: []

  toJSON: ->
    attributes = _.clone(@attributes)
    attributes.receipts_attributes = @get('receipts_attributes')
    { delivery: attributes }
