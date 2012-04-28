//= require underscore
//= require backbone
//= require backbone.authtokenadapter
//= require backbone-forms
//= require backbone-form-templates
//= require backbone-support

//= require_self
//= require besko/date

Besko = {
  Support: {},
  Views: {},

  init: function() {
    if ( typeof Backbone.history.started === 'undefined' ) {
      Backbone.history.start({pushState: true});
      Backbone.history.started = true;
    }
  }
};

$(function() { Besko.init() });

