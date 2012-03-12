@Notification =

  container: $ '#notifications'
  error: (message) -> @insert message, 'error'
  notice: (message) -> @insert message, 'notice'
  clear: -> @container.empty()

  insert: (message, klass) ->
    @initialize klass unless @initialized
    @messageContainer.toggleClass('error notice') unless @messageContainer.hasClass klass
    @message.text(message)

  initialize: (klass) ->
    @container = $('#notifications')
    if @container.children().length is 0
      @messageContainer = $('<div>').addClass klass
      @message = $('<span>').addClass 'message'
      @container.append @messageContainer.append @message
    else
      @message = @container.find('span.message')
      @messageContainer = @message.parent()
    @initialized = true
