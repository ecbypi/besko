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
    },

    routes: {
      "deliveries" : "deliveries",
      "accounts/signup" : "newAccount",
      "deliveries/new": "newDelivery"
    },

    // Signups
    newAccount: function() {
      var signupForm = new Besko.Views.SignupForm({
        collection: new Besko.Collections.Users({})
      });

      this.swap(signupForm);
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
    }
  });

  Besko.Router = Routes;
  Besko.Support.bootstrap = bootstrap;
})();
