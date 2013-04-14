(function() {
  "use strict";

  Besko.DeliveriesIndexRoute = Ember.Route.extend({
    setupController: function(controller, model) {
      controller.set('date', new Date());
    }
  });
})();
