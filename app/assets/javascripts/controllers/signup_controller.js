(function() {
  "use strict";

  Besko.SignupController = Ember.ArrayController.extend({
    search: function() {
      this.set('content', Besko.User.find({ term: this.get('query') }));
    },

    signup: function(user) {
      var transaction = this.get('store').transaction();

      user = transaction.createRecord(
        Besko.User,
        user.getProperties('firstName', 'lastName', 'email', 'login', 'street')
      );

      user.one('didCreate', this, function() {
        Besko.notice('An email has been sent requesting approval of your account.');
        this.setProperties({ content: [], query: '' });
      });

      transaction.commit();
    }
  });
})();
