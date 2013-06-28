(function() {
  'use strict';

  Besko.ForwardingAddress = DS.Model.extend({
    name: DS.attr('string'),
    street: DS.attr('string'),
    city: DS.attr('string'),
    state: DS.attr('string'),
    country: DS.attr('string'),
    postalCode: DS.attr('string'),

    labelCount: 1,
    labels: function() {
      var i, labels = [];

      for ( i = 0; i < this.get('labelCount'); i++ ) {
        labels.push(0);
      }

      return labels;
    }.property('labelCount'),

    suffix: function() {
      return this.get('city') + ', ' + this.get('state') + ' ' + this.get('postalCode');
    }.property('city', 'state', 'country', 'postalCode'),

    details: function() {
      return this.get('street') + ' ' + this.get('suffix');
    }.property('street', 'city', 'state', 'country', 'postalCode')
  });
})();
