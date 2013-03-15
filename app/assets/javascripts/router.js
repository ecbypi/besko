Besko.Router.reopen({
  location: 'history'
});

Besko.Router.map(function() {
  this.resource('deliveries', function() {
    this.route('new');
  });

  this.route('signup', { path: '/accounts/signup' });
});
