(function() {
  "use strict";

  Besko.Router = Backbone.Router.extend({

    routes: {
      'deliveries/new' : 'newDelivery',
      'deliveries(?:params)' : 'deliverySearch',
      'accounts/edit' : 'editAccount'
    },

    deliverySearch: function(params) {
      params = $.parseQueryObject(params);

      var search = new Besko.Views.DeliverySearch({
        el: $('#content'),
        params: params
      });

      search.render();
    },

    newDelivery: function() {
      var deliveryForm = new Besko.Views.DeliveryForm({
        el: $('#new-delivery'),
        collection: new Besko.Collections.Users()
      });

      deliveryForm.render();
    },

    editAccount: function() {
      new Besko.Views.EditAddressForm({
        el: $('#edit-address')
      });
    }
  });
})();