(function() {
  "use strict";

  Besko.User = DS.Model.extend({
    firstName: DS.attr('string'),
    lastName: DS.attr('string'),
    email: DS.attr('string'),
    login: DS.attr('string'),
    street: DS.attr('string'),

    name: function() {
      return this.get('firstName') + ' ' + this.get('lastName');
    }.property('firstName', 'lastName'),

    details: function() {
      return [this.get('email'), this.get('street')].compact().join(' | ');
    }.property('email', 'street')
  });
})();
