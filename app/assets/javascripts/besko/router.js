(function() {
  "use strict";

  Besko.Router = Backbone.Router.extend({

    routes: {
      'deliveries/new(?:params)' : 'newDelivery',
      'deliveries(?:params)' : 'deliverySearch',
      'accounts/edit' : 'editAccount'
    },

    deliverySearch: function(params) {
      var queryParams = {
        filter: null,
        sort: null
      }

      params = $.parseQueryObject(params);
      _.extend(queryParams, params);

      if ( !queryParams.filter ) {
        queryParams.filter = 'waiting';
      }

      if ( !queryParams.sort ) {
        queryParams.sort = 'newest';
      }

      window.history.replaceState(null, document.title, Routes.deliveries_path(queryParams));

      var search = new Besko.Views.DeliverySearch({
        el: $('#delivery-search')
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
