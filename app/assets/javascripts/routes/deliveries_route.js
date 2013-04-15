(function() {
  "use strict";

  Besko.DeliveriesRoute = Ember.Route.extend({
    model: function(params) {
      var date, offsetHours;

      if ( params.date ) {
        date = new Date(params.date);
        offsetHours = date.getTimezoneOffset() / 60;
        date.setUTCHours(offsetHours);
      } else {
        date = new Date();
      }

      this.controllerFor('deliveries').set('date', date);
    },

    serialize: function(model) {
      var date = this.controllerFor('deliveries').get('date');

      return { date: date.strftime('%Y-%m-%d') };
    },

    setupController: function(controller, model) {
      controller.addObserver('date', controller, 'dateChanged');
    }
  });
})();
