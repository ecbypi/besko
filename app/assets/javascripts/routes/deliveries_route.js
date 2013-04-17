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
      var controller = this.controllerFor('deliveries'),
          date = controller.get('date');

      if ( !date ) {
        date = new Date();
        controller.set('date', date);
      }

      return { date: date.strftime('%Y-%m-%d') };
    },

    setupController: function(controller, model) {
      controller.addObserver('date', controller, 'dateChanged');
      controller.addObserver('content', controller, 'setSortDirection');
    }
  });
})();
