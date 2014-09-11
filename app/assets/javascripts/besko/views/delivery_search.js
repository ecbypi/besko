/* global Cookies, Routes */
(function() {
  "use strict";

  Besko.Views.DeliverySearch = Backbone.View.extend({
    events: {
      'click [data-sort]' : function(event) {
        var $target     = $(event.target),
            url         = $target.attr('href'),
            queryString = url.split('?')[1],
            queryObject = $.parseQueryObject(queryString);

        Cookies.set('delivery_sort', queryObject.sort);
      }
    },

    initialize: function(options) {
      var params = options.params;

      this.pjaxContainerSelector = '#' + this.el.id;

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
    }
  });
})();
