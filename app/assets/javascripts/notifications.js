$(function() {
  "use strict";

  var container, message, initialized;

  function bind() {
    container = $('#notifications');

    container.on('click', 'a.close-message', function(event) {
      container.hide();
    });
  };

  function initialize(className) {
    if ( !container.length ) {
      bind();
    }

    if ( container.children().length === 0 ) {
      message = $('<div>').addClass('message ' + className);
      container.append(message);
      container.append(
        $('<a>').
          attr('href', 'javascript:void(0)').
          text('Close').
          addClass('close-message').addClass('close')
      );
    } else {
      message = container.children('div.message');
    }
  };

  function insert(text, className) {
    if ( !message ) {
      initialize(className);
    }

    if ( !message.hasClass(className) ) {
      message.toggleClass('error notice');
    }

    return message.text(text).parent().show();
  };

  Besko.error = function(text) {
    return insert(text, 'error');
  };

  Besko.notice = function(text) {
    return insert(text, 'notice');
  };

  bind();
});
