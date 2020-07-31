(function() {
  "use strict";

  Besko.Router = Backbone.Router.extend({

    routes: {
      'deliveries/new(?:params)' : 'newDelivery'
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
    }
  });
})();
