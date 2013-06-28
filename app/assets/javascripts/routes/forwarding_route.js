(function() {
  'use strict';

  Besko.ForwardingRoute = Ember.Route.extend({
    model: function() {
      return Ember.ArrayProxy.create({ content: [] });
    }
  });
})();
