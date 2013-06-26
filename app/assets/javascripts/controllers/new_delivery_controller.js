/*global cookie:true */
(function() {
  "use strict";

  Besko.NewDeliveryController = Ember.ArrayController.extend(Besko.AutocompleteMixin, {
    delivery: null,

    tableVisible: function() {
      return this.get('content.length') > 0 && !this.get('delivery.isSaving');
    }.property('content.@each', 'delivery.isSaving'),

    recipientIds: function() {
      return this.get('content').mapProperty('user.id');
    }.property('content.@each'),

    search: function(term) {
      this.set('autocompleteResults', Besko.Recipient.find({ term: term }));
    },

    add: function(recipient) {
      if ( !recipient.get('id') ) {
        var transaction = this.get('store').transaction();

        recipient = transaction.createRecord(
          Besko.Recipient,
          recipient.getProperties('firstName', 'lastName', 'email', 'login', 'street')
        );

        recipient.one('didCreate', this, function() {
          this._add(recipient);
        });

        transaction.commit();
      } else {
        this._add(recipient);
      }
    },

    _add: function(recipient) {
      // We parse the id from a string into an integer since the bootstrapped
      // JSON returns integers instead of strings as Ember serializes them
      var receipt, recipientIds = this.get('recipientIds');

      if ( recipientIds.contains(recipient.get('id')) ) {
        receipt = this.get('content').findProperty('user.id', recipient.get('id'));
        receipt.incrementProperty('numberPackages');
      } else {
        receipt = Besko.Receipt.createRecord({
          user: recipient,
          numberPackages: 1
        });

        this.get('content').pushObject(receipt);
      }

      this.set('autocompleteResults', []);
    },

    remove: function(receipt) {
      this.get('content').removeObject(receipt);
    },

    submit: function() {
      var transaction, delivery;

      if ( Ember.isEmpty(this.get('deliverer')) ) {
        Besko.error('A deliverer is required to log a delivery.');
        return false;
      } else if ( Ember.isEmpty(this.get('content')) ) {
        Besko.error('At least one recipient is required.');
        return false;
      }

      transaction = this.get('store').transaction();

      delivery = transaction.createRecord(Besko.Delivery, {
        receiptsAttributes: this.get('content'),
        deliverer: this.get('deliverer')
      });

      this.set('delivery', delivery);

      delivery.on('didCreate', this, function() {
        Besko.notice('Notifications Sent');
        this.clear();
        this.transitionToRoute('deliveries');
      });

      transaction.commit();
    },

    clear: function() {
      this.set('content', []);
      this.set('deliverer', '');
    },

    updateCookies: function() {
      cookie.set('recipients', this.get('recipientIds'));
    }.observes('recipientIds')
  });
})();
