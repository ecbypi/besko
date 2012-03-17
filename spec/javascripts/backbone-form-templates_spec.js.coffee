#= require application

describe "custom Backbone.Form.templates", ->

  describe "wraps inputs similar to simple_form defaults", ->
    beforeEach ->
      @form = new Backbone.Form(
        schema:
          name:
            validators: ['required']
            title: 'Your Name'
            help: 'On your birth certificiate'
      )
      @form.render()

    it "wraps fieldsets as div.inputs", ->
      expect(@form.$el).toContain('div.inputs')

    it "wraps label/input elements in div.input", ->
      expect(@form.$('div.inputs')).toContain('div.input')

    it "adds default rails/simple_form error class", ->
      @form.validate()
      expect(@form.$el).toContain('div.input.field_with_errors')
