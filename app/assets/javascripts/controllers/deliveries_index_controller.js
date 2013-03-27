Besko.DeliveriesIndexController = Ember.ArrayController.extend({
  itemController: 'delivery',

  dateFormat: '%A, %B %d, %Y',

  formattedDate: function() {
    return this.get('date').strftime(this.get('dateFormat'));
  }.property('date'),

  fetch: function() {
    var iso = this.get('date').strftime('%Y-%m-%d');

    this.set('content', Besko.Delivery.find({ date: iso }));
  }.observes('date'),

  prevDay: function() {
    this.set('date', this.get('date').decrement());
  },

  nextDay: function () {
    this.set('date', this.get('date').increment());
  },

  toggleReceipts: function(controller) {
    controller.toggleProperty('expanded');
  }
});
