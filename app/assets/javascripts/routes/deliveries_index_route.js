Besko.DeliveriesIndexRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    controller.set('date', Besko.Date());
  }
});
