class @Besko.Models.Receipt extends Backbone.Model

  urlRoot: '/receipts'

  defaults:
    number_packages: 1

  initialize: (attributes) ->
    @loadRecipient(attributes.recipient) if attributes

  loadRecipient: (recipient) ->
    if recipient?
      if recipient.constructor && recipient.constructor is Besko.Models.User
        @recipient = recipient
      else
        @recipient = new Besko.Models.User(recipient)

      unless @recipient.id?
        @recipient.save({}, success: (user, response) => @set('recipient_id', user.id))
      else
        @set('recipient_id', @recipient.id)
