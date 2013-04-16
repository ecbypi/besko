/*global cookie:true*/
(function() {
  "use strict";

  Besko.DeliveriesController = Ember.ArrayController.extend({
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

    dateChanged: function() {
      this.transitionToRoute('deliveries');
    },

    setSortDirection: function() {
      var direction = cookie.get('delivery_sort') || 'down';
      direction = direction === 'down' ? true : false;

      this.set('sortAscending', direction);
      this.removeObserver('content', this, 'setSortDirection');
    },

    prevDay: function() {
      this.set('date', this.get('date').decrement());
    },

    nextDay: function() {
      this.set('date', this.get('date').increment());
    },

    reverseSorting: function() {
      this.toggleProperty('sortAscending');

      var direction = this.get('sortAscending') ? 'down' : 'up';
      cookie.set('delivery_sort', direction, { path: '/deliveries' });
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
