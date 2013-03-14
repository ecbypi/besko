DS.RESTAdapter.configure('plurals', {
  delivery: 'deliveries'
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
