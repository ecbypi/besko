Besko.DeliveriesIndexController = Ember.ArrayController.extend({
  itemController: 'delivery',

  dateFormat: '%A, %B %d, %Y',

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

  nextDay: function () {
    this.set('date', this.get('date').increment());
  },

  toggleReceipts: function(controller) {
    controller.toggleProperty('expanded');
  },

  remove: function(delivery) {
    delivery.one('didDelete', this, function() {
      this.get('content').removeObject(delivery);
    });

    delivery.deleteRecord();

    this.get('store').commit();
  }
});
