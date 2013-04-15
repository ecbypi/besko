(function() {
  "use strict";

  Besko.Router.reopen({
    location: 'history'
  });

  Besko.Router.map(function() {
    this.route('deliveries');
    this.route('deliveries', { path: '/deliveries/:date' });
    this.route('new_delivery', { path: '/deliveries/new' });

    this.route('signup', { path: '/accounts/signup' });

    this.route('user_roles', { path: '/roles' });
    this.route('user_roles', { path: '/roles/:role' });
  });
})();
