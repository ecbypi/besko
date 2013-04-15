(function() {
  "use strict";

  Besko.DeliveriesRoute = Ember.Route.extend({
    setupController: function(controller, model) {
      controller.set('date', new Date());
    }
  });
})();
