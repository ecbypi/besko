Besko.DeliveriesNewRoute = Ember.Route.extend({
  setupController: function(controller, model) {
    controller.set('content', Ember.ArrayProxy.create({ content: [] }));
    controller.set('deliverers', Besko.parseEmbeddedJSON('#deliverers'));
  }
});
