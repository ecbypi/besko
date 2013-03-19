//= require_self

//= require notifications
//= require parsing
//= require date

//= require ./store
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./templates
//= require ./router
//= require_tree ./routes

window.Besko = Ember.Application.create({
  rootElement: '#wrapper'
});

Besko.startRouting = function() {
  var router = this.__container__.lookup('router:main');

  if (!router) { return; }

  try {
    router.startRouting();
  } catch(e) {
    if ( !e.message.match(/No route matched the URL/) ) {
      throw(e);
    }
  }
};

// The current implementation of Ember.HistoryLocation#getURL() ignores
// window.location.search and throws it away when calling #replaceState().
// Overriding getURL to tack on any search params present in order to preserve
// them.
Ember.HistoryLocation.reopen({
  getURL: function() {
    var url = this._super();

    return url + Ember.get(this, 'location').search
  }
});
