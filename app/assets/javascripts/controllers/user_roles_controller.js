(function() {
  "use strict";

  Besko.UserRolesController = Ember.ArrayController.extend({
    roleChanged: function() {
      this.get('target').transitionTo('user_roles');

      var roles = Besko.UserRole.find({ title: this.get('currentRole') });

      var self = this;
      roles.on('didLoad', function() {
        self.set('content.content', this.toArray());
      });
    },

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

      var self = this;
      role.one('didCreate', function() {
        var roles = self.get('content.content'),
            proxy = Ember.ArrayProxy.create({ content: roles });

        roles.splice(0, 0, this);
        proxy.set('content', roles);

        self.set('content', proxy);
        Besko.notice(role.get('user.name') + ' is now a ' + self.get('currentRole'));
      });

      this.get('store').commit();
    },

    remove: function(role) {
      if ( confirm('Remove ' + role.get('name') + ' from the position ' + this.get('title') + '?') ) {
        var name = role.get('user.name');
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
