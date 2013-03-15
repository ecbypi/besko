Besko.DeliveryController = Ember.ObjectController.extend({
  mailTo: function() {
    return "mailto:" + this.get('worker.email');
  }.property('worker.email')
});
