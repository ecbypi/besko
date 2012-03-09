class @Besko.Models.Receipt extends Backbone.Model

  urlRoot: '/receipts'

  initialize: (attributes) ->
    if attributes && attributes.recipient
      @attributes.recipient_id = attributes.recipient.id

  defaults:
    number_packages: 1
