(function() {
  "use strict";

  Besko.DeliveryController = Ember.ObjectController.extend({
    mailTo: function() {
      return "mailto:" + this.get('user.email');
    }.property('user.email'),

    formattedDeliveredAt: function() {
      return new Date(this.get('deliveredAt')).strftime('%I:%M:%S %P');
    }.property('deliveredAt')
  });
})();
