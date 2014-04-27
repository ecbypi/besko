/* global Routes */
(function() {
  'use strict';

  Besko.Views.EditAddressForm = Backbone.View.extend({
    events: {
      'change [data-country]' : 'updateSubregions'
    },

    initialize: function() {
      this.$subregion = this.$('[data-subregion]');
    },

    updateSubregions: function(event) {
      var code = event.target.value;

      this.$subregion.load(Routes.subregions_path({ code: code }));
    }
  });
})();
