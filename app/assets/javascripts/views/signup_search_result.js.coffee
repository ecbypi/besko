class @Besko.Views.SignupSearchResult extends Support.CompositeView

  tagName: 'tr'
  attributes:
    'data-resource': 'user'

  events:
    'click button[data-role=commit]' : 'save'

  render: ->
    html = window.JST['registrations/result'](user: @model)
    this.$el.html(html)
    this

  save: ->
    @model.save()
