class @Besko.Views.SignupSearchResult extends Support.CompositeView

  tagName: 'tr'
  attributes:
    'data-resource': 'user'

  events:
    'click button[data-role=commit]' : 'save'

  render: ->
    this.$el.html window.JST['registrations/result'] user: @model
    this

  save: ->
    @model.save()
