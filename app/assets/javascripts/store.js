(function() {
  "use strict";

  DS.RESTAdapter.configure('plurals', {
    delivery: 'deliveries',
    user_role: 'roles'
  });

  DS.RESTAdapter.map('Besko.Delivery', {
    receipts: { embedded: 'load' }
  });

  DS.RESTAdapter.registerTransform('nestedAttributesArray', {
    serialize: function(value) {
      return value.map(function(object) {
        return object.serialize();
      });
    },

    deserialize: function(value) {
      return value;
    }
  });

  Besko.Store = DS.Store.extend({
    revision: 11
  });
})();
