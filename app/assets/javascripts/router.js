(function() {
  "use strict";

  Besko.Router.reopen({
    location: 'history'
  });

  Besko.Router.map(function() {
    this.resource('deliveries');
    this.route('new_delivery', { path: '/deliveries/new' });

    this.route('signup', { path: '/accounts/signup' });

    this.resource('user_roles', { path: '/roles' });
    this.resource('user_roles', { path: '/roles/:role' });
  });
})();
