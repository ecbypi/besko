#= require application

describe "Besko.Views.SignupSearchResult", ->
  beforeEach ->
    @user = new Besko.Models.User(
      first_name: 'Micro'
      last_name: 'Helpline'
      email: 'mrhalp@mit.edu'
      login: 'mrhalp'
    )
    @view = new Besko.Views.SignupSearchResult model: @user
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

  it "has a button to save the user if no id is present", ->
    expect(@view.$el).toContain('button[data-role=commit]')

  it "has no button if id is present on model", ->
    @user.set('id', 1)
    @view.render()
    expect(@view.$el).not.toContain('button[data-role=commit]')
    expect(@view.$el).toHaveText(/Account Exists/)

  it "saves the model when the button is pressed", ->
    sinon.spy(@user, 'save')
    @view.$('button[data-role=commit]').click()
    expect(@user.save).toHaveBeenCalled()
    @user.save.restore()
