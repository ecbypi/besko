(function() {
  "use strict";

  Besko.Router = Backbone.Router.extend({

    routes: {
      'deliveries/new(?:params)' : 'newDelivery',
      'deliveries(?:params)' : 'deliverySearch',
      'accounts/edit' : 'editAccount'
    },

    deliverySearch: function(params) {
      params = $.parseQueryObject(params);

      var search = new Besko.Views.DeliverySearch({
        el: $('#delivery-search'),
        params: params
      });

      search.render();
    },

    newDelivery: function(params) {
      params = $.parseQueryObject(params);

      var recipients = params.r || {};

      _.each(recipients, function(count, recipient) {
        recipients[recipient] = parseInt(count, 10);
      });

      var deliveryForm = new Besko.Views.DeliveryForm({
        el: $('#new-delivery'),
        recipients: recipients
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
