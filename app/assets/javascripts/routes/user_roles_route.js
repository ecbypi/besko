(function() {
  "use strict";

  Besko.UserRolesRoute = Ember.Route.extend({
    model: function(params) {
      if ( params.role ) {
        this.controllerFor('user_roles').set('currentRole', params.role);
      }
    },

    serialize: function(model) {
      return { role: this.controllerFor('user_roles').get('currentRole') };
    },

    setupController: function(controller, model) {
      var roles = Besko.parseEmbeddedJSON('#roles');
      controller.set('roles', roles);
    }
  });
})();
