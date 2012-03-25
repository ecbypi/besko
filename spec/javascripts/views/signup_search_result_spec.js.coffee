#= require application

describe "Besko.Views.SignupSearchResult", ->
  beforeEach ->
    @user = new Besko.Models.User(
      first_name: 'Micro'
      last_name: 'Helpline'
      email: 'mrhalp@mit.edu'
      login: 'mrhalp'
      street: 'N42'
    )
    @view = new Besko.Views.SignupSearchResult(model: @user)
    @view.render()

  it "is a table row", ->
    expect(@view.$el).toBe('tr')

  it "represents a user model", ->
    expect(@view.$el).toHaveData('resource', 'user')

  it "has the user's name", ->
    expect(@view.$el).toHaveText(/Micro Helpline/)

  it "has the user's email", ->
    expect(@view.$el).toHaveText(/mrhalp@mit.edu/)

  it "has the user's kerberos/login", ->
    expect(@view.$el).toHaveText(/mrhalp/)

  it "has the user's street/address", ->
    expect(@view.$el).toHaveText(/N42/)

  it "has a checkbox to confirm selection of result", ->
    expect(@view.$el).toContain('input[type=checkbox]')

  it "has a disabled button to save the user if no id is present", ->
    expect(@view.$el).toContain('button[data-role=commit]:disabled')

  it "has no button if id is present on model", ->
    @user.set('id', 1)
    @view.render()
    expect(@view.$el).not.toContain('button[data-role=commit]')
    expect(@view.$el).not.toContain('input[type=checkbox]')
    expect(@view.$el).toHaveText(/Account Exists/)

  describe "checking the confirmation box", ->
    it "enables the button", ->
      @view.$('input[type=checkbox]').attr('checked', true)
      @view.$('input[type=checkbox]').click()
      expect(@view.$('button[data-role=commit]')).not.toBe(':disabled')
