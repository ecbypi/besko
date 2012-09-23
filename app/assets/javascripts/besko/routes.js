(function() {
  var bootstrap, Routes;

  bootstrap = function(ctor) {
    var script, tmp, json;

    script = $('script#bootstrap');
    if ( script.length > 0 ) {
      tmp = document.createElement('div');
      tmp.innerHTML = script.text();
      json = JSON.parse(tmp.innerHTML);
      return new ctor(json.data);
    } else {
      return new ctor();
    }
  };

  Routes = Support.SwappingRouter.extend({
    initialize: function() {
      this.el = document.getElementById('content');
      this.route(/^deliveries\?date=(\d{4}-\d{2}-\d{2})$/, 'deliveries');
      this.route(/^admin\/roles\?title=(\w+)$/, 'roles');
    },

    routes: {
      "deliveries" : "deliveries",
      "accounts/signup" : "newAccount",
      "deliveries/new": "newDelivery",
      "admin/roles" : "roles"
    },

    // Signups
    newAccount: function() {
      new Besko.Views.SignupForm({
        el: this.el,
        collection: new Besko.Collections.Users
      });
    },

    // Deliveries
    deliveries: function(date) {
      var collection = bootstrap(Besko.Collections.Deliveries),
          el = document.getElementById('content'),
          search = new Besko.Views.DeliverySearch({
            collection: collection,
            date: date,
            el: el,
          });

      search.render();
    },

    newDelivery: function() {
      var el = document.getElementById('new_delivery'),
          form = new Besko.Views.DeliveryForm({
            el: el
          });
    },

    roles: function(title) {
      var el = document.getElementById('content'),
          roles = bootstrap(Besko.Collections.UserRoles);

      roles = new Besko.Views.RoleManagement({
        el: el,
        collection: roles
      });
    }
  });

  Besko.Router = Routes;
  Besko.Support.bootstrap = bootstrap;
})();
