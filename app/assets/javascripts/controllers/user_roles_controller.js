(function() {
  "use strict";

  Besko.UserRolesController = Ember.ArrayController.extend({
    roleChanged: function() {
      var self = this, params = {
        title: this.get('currentRole')
      };

      this.transitionToRoute('user_roles');

      Besko.UserRole.find(params).then(function(roles) {
        self.set('content', roles.toArray());
      });
    }.observes('currentRole'),

    sortAscending: false,
    sortProperties: ['createdAt'],

    autocompleteSearching: function() {
      return this.get('autocompleteResults.isLoaded') === false;
    }.property('autocompleteResults.isLoaded'),

    search: function(term) {
      this.set('autocompleteResults', Besko.User.find({ term: term, options: { local_only: true }}));
    },

    add: function(user) {
      var role = Besko.UserRole.createRecord({
        title: this.get('currentRole'),
        userId: user.get('id'),
        user: user
      });

      role.one('didCreate', this, function() {
        this.get('content').addObject(role);
        Besko.notice(role.get('user.name') + ' is now a ' + this.get('currentRole'));
      });

      this.get('store').commit();
    },

    remove: function(role) {
      var name = role.get('user.name');

      if ( confirm('Remove ' + name + ' from the position ' + this.get('title') + '?') ) {
        role.one('didDelete', this, function() {
          this.get('content').removeObject(role);
          Besko.notice(name + ' is no longer a ' + this.get('currentRole'));
        });

        role.deleteRecord();

        this.get('store').commit();
      }
    }
  });
})();
