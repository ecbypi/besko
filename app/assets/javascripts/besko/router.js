(function() {
  "use strict";

  Besko.Router = Backbone.Router.extend({

    routes: {
      'deliveries(?:params)' : 'deliverySearch'
    },

    deliverySearch: function(params) {
      params = $.parseQueryObject(params);

      var search = new Besko.Views.DeliverySearch({
        el: $('#content'),
        params: params
      });

      search.render();
    }
  });
})();
