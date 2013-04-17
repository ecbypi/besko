(function() {
  "use strict";

  Besko.UserRole = DS.Model.extend({
    title: DS.attr('string'),
    user: DS.belongsTo('Besko.User'),
    userId: DS.attr('number'),
    createdAt: DS.attr('date'),

    added: function() {
      return this.get('createdAt').strftime('%a %b %d %H:%M:%S %Y');
    }.property('createdAt'),

    becameInvalid: function(model) {
      Besko.error('User is already in the selected role');
    }
  });
})();
