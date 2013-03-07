//= require_self

//= require notifications

//= require ./store
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./templates
//= require ./router
//= require_tree ./routes

window.Besko = Ember.Application.create({
  rootElement: '#wrapper'
});
