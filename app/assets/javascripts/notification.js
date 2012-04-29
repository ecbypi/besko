var Notification = {

  container: $('#notifications'),
  error: function(message) { this.insert(message, 'error'); },
  notice: function(message) { this.insert(message, 'notice'); },
  clear: function() { this.container.hide() },

  insert: function(message, className) {
    if ( !this.initialized ) this.initialize(className);
    if ( !this.message.hasClass(className) ) this.message.toggleClass('error notice');

    this.message.text(message);
    return this.message;
  },

  initialize: function(className) {
    this.container = $('#notifications');
    if ( this.container.children().length === 0 ) {
      this.message = $('<div>').addClass('message ' + className);
      this.container.append(this.message);
      this.container.append(
        $('<a>').
          attr('href', 'javascript:void(0)').
          text('Close').
          addClass('close-message')
      );
    } else {
      this.message = this.container.children('div.message');
    }

    this.container.children('a.close-message').click(function(event) { Notification.clear(); });
    this.initialized = true;
  }
}
