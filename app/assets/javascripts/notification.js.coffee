@Notification =

  container: $ '#notifications'
  error: (message) -> @insert message, 'error'
  notice: (message) -> @insert message, 'notice'
  clear: -> @container.hide()

  insert: (message, klass) ->
    @initialize klass unless @initialized
    @message.toggleClass('error notice') unless @message.hasClass klass
    @message.text(message)

  initialize: (klass) ->
    @container = $('#notifications')
    if @container.children().length is 0
      @message = $('<div>').addClass "message #{klass}"
      @container.append @message
      @container.append $('<a>').
        attr('href', 'javascript:void(0)').
        text('Close').
        addClass('close-message')
    else
      @message = @container.children('div.message')
    @container.children('a.close-message').click (event) ->
      Notification.clear()
    @initialized = true
    this
