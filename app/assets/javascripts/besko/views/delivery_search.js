/* global Cookies, Routes */
(function() {
  "use strict";

  Besko.Views.DeliverySearch = Backbone.View.extend({
    events: {
      'change [data-sort]' : function(event) {
        var sorting = $(event.target).val();

        Cookies.set('delivery_sort', sorting);
      },
      'change [data-deliveries-filter]' : function(event) {
        $(event.target).submit();
      },
      'submit [data-deliveries-filter]' : 'filterDeliveries'
    },

    initialize: function(options) {
      var params = {
        filter: null,
        sort: null
      }

      _.extend(params, options.params);

      this.pjaxContainerSelector = '#' + this.el.id;

      if ( !params.filter ) {
        params.filter = 'waiting';
      }

      if ( !params.sort ) {
        params.sort = Cookies.get('delivery_sort') || 'newest';
      }

      if ( !Cookies.get('delivery_sort') ) {
        Cookies.set('delivery_sort', params.sort);
      }

      window.history.replaceState(null, document.title, Routes.deliveries_path(params));
    },

    render: function() {
      this.$el.pjax('[data-pjax]', this.pjaxContainerSelector);

      return this;
    },

    filterDeliveries: function(event) {
      $.pjax.submit(event, this.pjaxContainerSelector);
    }
  });
})();
