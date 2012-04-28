//= require backbone.authtokenadapter
//= require backbone-form-templates

//= require_self
//= require besko/date
//= require besko/models
//= require besko/collections
//= require besko/routes

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

