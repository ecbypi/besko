/*global cookie:true*/
(function() {
  'use strict';

  Besko.ForwardingRoute = Ember.Route.extend({
    model: function() {
      var addresses = Besko.parseEmbeddedJSON('#addresses'),
          mappings  = cookie.get('addresses'),
          count;

      mappings = mappings ? JSON.parse(mappings) : {};

      this.get('store').loadMany(Besko.ForwardingAddress, addresses);

      return addresses.map(function(address) {
        address = Besko.ForwardingAddress.find(address.id);
        count   = mappings[address.get('id')] || 1;

        address.set('labelCount', count);

        return address;
      });
    },

    setupController: function(controller, model) {
      var state = cookie.get('forwardingState');
      state = state ? JSON.parse(state) : {};

      controller.set('printing', state.printing);
    }
  });
})();
