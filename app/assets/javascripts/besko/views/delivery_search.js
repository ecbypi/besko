/* global Cookies, Routes */
(function() {
  "use strict";

  Besko.Views.DeliverySearch = Backbone.View.extend({
    events: {
      'change [data-sort]' : 'updateSortingCookie',
      'change select' : 'submitForm',
      'submit' : 'filterDeliveries'
    },

    initialize: function(options) {
      var params = {
        filter: null,
        sort: null
      }

      _.extend(params, options.params);

      this.pjaxContainerSelector = '[data-pjax-container]';

      if ( !params.filter ) {
        params.filter = 'waiting';
      }

      if ( !params.sort ) {
        params.sort = Cookies.get('delivery_sort') || 'newest';
      }

      window.history.replaceState(null, document.title, Routes.deliveries_path(params));
    },

    filterDeliveries: function(event) {
      $.pjax.submit(event, this.pjaxContainerSelector);
    },

    submitForm: function() {
      this.$el.submit();
    },

    updateSortingCookie: function(event) {
      var sorting = $(event.target).val();

      Cookies.set('delivery_sort', sorting);
    }
  });
})();
