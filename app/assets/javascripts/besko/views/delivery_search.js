/* global Cookies, Routes */
(function() {
  "use strict";

  Besko.Views.DeliverySearch = Backbone.View.extend({
    events: {
      'change [data-sort]' : 'updateSortingCookie',
      'change select' : 'submitForm',
      'submit' : 'filterDeliveries'
    },

    initialize: function() {
      this.pjaxContainerSelector = '[data-pjax-container]';
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
