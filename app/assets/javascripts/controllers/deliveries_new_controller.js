Besko.DeliveriesNewController = Ember.ArrayController.extend({
  users: [],

  hasReceipts: function() {
    return this.get('content.length') > 0;
  }.property('content.@each'),

  search: function(term) {
    this.set('users', Besko.User.find({ term: term }));
  },

  add: function(recipient) {
    var receipt = Besko.Receipt.createRecord({
      recipient: recipient,
      recipientId: recipient.get('id'),
      numberPackages: 1
    });

    this.get('content').pushObject(receipt);
    this.set('users', []);
  },

  remove: function(receipt) {
    this.get('content').removeObject(receipt);
  },

  submit: function() {
    if ( Ember.isEmpty(this.get('deliverer')) ) {
      Besko.error('A deliverer is required to log a delivery.');
      return false;
    } else if ( Ember.isEmpty(this.get('content')) ) {
      Besko.error('At least one recipient is required.');
      return false;
    }

    var transaction = this.get('store').transaction()

    var delivery = transaction.createRecord(Besko.Delivery, {
      receiptsAttributes: this.get('content'),
      deliverer: this.get('deliverer')
    });

    var self = this;
    delivery.on('didCreate', function() {
      Besko.notice('Notifications Sent');
      self.clear();
    });

    transaction.commit();
  },

  clear: function() {
    this.set('content.content', []);
    this.set('deliverer', '');
  }
});
