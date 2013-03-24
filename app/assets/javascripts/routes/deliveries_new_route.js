Besko.DeliveriesNewRoute = Ember.Route.extend({
  model: function() {
    var recipients = Besko.parseEmbeddedJSON('#recipients');

    this.get('store').loadMany(Besko.User, recipients);

    return recipients.map(function(user) {
      return Besko.Receipt.createRecord({
        recipient: Besko.User.find(user.id),
        recipientId: user.id,
        numberPackages: 1
      });
    });
  },

  setupController: function(controller, model) {
    controller.set('deliverers', Besko.parseEmbeddedJSON('#deliverers'));
  }
});
