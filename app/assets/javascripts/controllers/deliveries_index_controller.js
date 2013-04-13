(function() {
  "use strict";

  Besko.DeliveriesIndexController = Ember.ArrayController.extend({
    itemController: 'delivery',

    dateFormat: '%a, %b %d, %Y',

    sortProperties: ['deliveredAt'],

    formattedDate: function() {
      return this.get('date').strftime(this.get('dateFormat'));
    }.property('date'),

    fetch: function() {
      var self = this,
          iso = this.get('date').strftime('%Y-%m-%d');

      Besko.Delivery.find({ date: iso }).then(function(deliveries) {
        self.set('content', deliveries.toArray());
      });
    }.observes('date'),

    prevDay: function() {
      this.set('date', this.get('date').decrement());
    },

    nextDay: function() {
      this.set('date', this.get('date').increment());
    },

    sort: function() {
      this.toggleProperty('sortAscending');
    },

    toggleReceipts: function(controller) {
      controller.toggleProperty('expanded');
    },

    remove: function(delivery) {
      var deliverer = delivery.get('deliverer'),
          name = delivery.get('user.name');

      if ( confirm('Delete delivery from ' + deliverer + ' received by ' + name + '?') ) {
        delivery.one('didDelete', this, function() {
          this.get('content').removeObject(delivery);
        });

        delivery.deleteRecord();

        this.get('store').commit();
      }
    }
  });
})();
