#= require application

describe "Besko.Models.Receipt", ->
  beforeEach ->
    @receipt = new Besko.Models.Receipt()

  it "defaults number of packages to 1", ->
    numberPackages = @receipt.get('number_packages')
    expect(numberPackages).toEqual(1)


describe "Besko.Models.Receipt.initialize", ->
  beforeEach ->
    @server = sinon.fakeServer.create()
    @server.respondWith(
      'POST'
      '/users'
      [
        201
        { 'Content-Type' : 'application/json' }
        '{ "id": 1, "first_name": "Micro", "last_name": "Helpline", "email": "mrhalp@.mit.edu", "login": "mrhalp" }'
      ]
    )
    @receipt = new Besko.Models.Receipt(
      recipient:
        first_name: 'Micro'
        last_name: 'Helpline'
        email: 'mrhalp@mit.edu'
        login: 'mrhalp'
    )
    @server.respond()

  afterEach ->
    @server.restore()

  it "instantiates a user model from recipient if passed in", ->
    expect(@receipt.recipient.constructor).toEqual(Besko.Models.User)

  it "saves the user if unpersisted", ->
    expect(@receipt.recipient.id).toEqual(1)

  it "sets recipient_id", ->
    receipt = new Besko.Models.Receipt(recipient: { id: 1 })
    expect(receipt.get('recipient_id')).toEqual(1)
    expect(@receipt.get('recipient_id')).toEqual(1)

  it "accepts a user model instance", ->
    user = new Besko.Models.User()
    receipt = new Besko.Models.Receipt(
      recipient: user
    )
    expect(receipt.recipient).toEqual(user)

describe "Besko.Models.Receipt.schema", ->
  beforeEach ->
    @receipt = new Besko.Models.Receipt(recipient: { id: 1 })
    @schema = @receipt.schema()

  it "includes information for number_packages", ->
    expect(_.isObject(@schema.number_packages)).toBeTruthy()

  it "includes information for comment", ->
    expect(_.isObject(@schema.comment)).toBeTruthy()

  it "includes information for recipient_id", ->
    expect(_.isObject(@schema.recipient_id)).toBeTruthy()
