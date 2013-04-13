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
      var iso = this.get('date').strftime('%Y-%m-%d'),
          deliveries = Besko.Delivery.find({ date: iso });

      deliveries.on('didLoad', this, function() {
        this.set('content', deliveries.toArray());
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
