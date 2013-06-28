(function() {
  'use strict';

  Besko.ForwardingAddress = DS.Model.extend({
    name: DS.attr('string'),
    street: DS.attr('string'),
    city: DS.attr('string'),
    state: DS.attr('string'),
    country: DS.attr('string'),
    postalCode: DS.attr('string')
  });
})();
