//= require_self

//= include besko/auth_token_adapter.js

//= require besko/notifications
//= require besko/date
//= require besko/models
//= require besko/collections
//= require besko/routes
//= require besko/views

Besko = {
  Support: {},
  Views: {},

  init: function() {
    new Besko.Router();

    if ( typeof Backbone.history.started === 'undefined' ) {
      Backbone.history.start({pushState: true});
      Backbone.history.started = true;
    }
  }
};

$(function() { Besko.init() });

