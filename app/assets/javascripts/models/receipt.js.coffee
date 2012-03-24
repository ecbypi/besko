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

      if !@recipient.id?
        @recipient.save({}, success: (user, response) => @set('recipient_id', user.id))
      else
        @set('recipient_id', @recipient.id)

      @set('recipient', undefined)

  schema: ->
    schema =
      recipient_id:
        fieldClass: 'hidden required'
        editorAttrs:
          type: 'hidden'
        validators: ['required']
      number_packages:
        dataType: 'number'
        title: 'Number of Packages'
        fieldClass: 'number required'
        editorClass: 'number required'
        editorAttrs:
          min: 1
        validators: ['required']
      comment:
        type: 'TextArea'
        title: 'Comments'
        fieldClass: 'text optional'

    if @recipient?
      schema.recipient_id.title = @recipient.name()
    else
      schema.recipient_id.title = 'No Name'

    schema
