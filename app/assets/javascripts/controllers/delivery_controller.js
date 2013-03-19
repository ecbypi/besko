Besko.DeliveryController = Ember.ObjectController.extend({
  mailTo: function() {
    return "mailto:" + this.get('user.email');
  }.property('user.email')
});
