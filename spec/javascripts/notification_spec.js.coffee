#= require application

describe "Notification", ->
  beforeEach ->
    loadFixtures 'notifications'
    Notification.initialized = false
    @notifications = $('#notifications')

  describe ".error", ->
    it "updates the notification area as an error message", ->
      Notification.error('Warning!')
      expect(@notifications).toContain('.error')
      expect(@notifications).toHaveText('Warning!')

  describe ".notice", ->
    it "updates the notification area as a notice message", ->
      Notification.notice('Hey there!')
      expect(@notifications).toContain('.notice')
      expect(@notifications).toHaveText('Hey there!')

  describe ".clear", ->
    it "empties the notification container", ->
      Notification.notice('Hey!')
      Notification.clear()
      expect(@notifications).toBeEmpty()
