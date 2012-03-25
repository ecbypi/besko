class @Besko.Views.SignupSearchResult extends Support.CompositeView

  tagName: 'tr'
  attributes:
    'data-resource': 'user'

  events:
    'click button[data-role=commit]' : 'commit'
    'click input[type=checkbox]' : 'toggleButtonDisability'

  render: ->
    html = window.JST['registrations/search_result'](user: @model)
    this.$el.html(html)
    this.$button = this.$('button')
    this.$checkbox = this.$('input')
    this

  toggleButtonDisability: ->
    if this.$checkbox.is(':checked')
      this.$button.removeAttr('disabled')
    else
      this.$button.attr('disabled', 'disabled')

  commit: ->
    if this.$checkbox.is(':checked')
      return @model.save({},
        success: (model, response) ->
          Notification.notice('An email has been sent requesting approval of your account.')
        failure: (model, response) ->
          Notification.error('There was a problem saving you\'re account')
      )
    else
      this.$('.error').text('Confirmation must be checked')
      return false
