Besko.UserRolesRoute = Ember.Route.extend({
  model: function(params) {
    var proxy = Ember.ArrayProxy.create({ content: [] });

    if ( params.role ) {
      var roles = Besko.UserRole.find({ title: params.role });

      roles.on('didLoad', function() {
        proxy.set('content', this.toArray());
      });

      this.controllerFor('user_roles').set('currentRole', params.role);
    }

    return proxy;
  },

  serialize: function(model) {
    return { role: this.controllerFor('user_roles').get('currentRole') };
  },

  setupController: function(controller, model) {
    var roles = Besko.parseEmbeddedJSON('#roles');

    controller.setProperties({
      content: model,
      roles: roles
    });

    controller.addObserver('currentRole', controller, 'roleChanged');
  }
});
