/* global Support, Spinner */
(function() {
  'use strict';

  var spinnerOptions = {
    large: {
      lines: 13, // The number of lines to draw
      length: 13, // The length of each line
      width: 6, // The line thickness
      radius: 15, // The radius of the inner circle
      corners: 0.7, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      color: '#000', // #rgb or #rrggbb
      speed: 0.8, // Rounds per second
      trail: 45, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: 'auto', // Top position relative to parent in px
      left: 'auto' // Left position relative to parent in px
    },
    small: {
      lines: 9, // The number of lines to draw
      length: 4, // The length of each line
      width: 3, // The line thickness
      radius: 6, // The radius of the inner circle
      corners: 0.9, // Corner roundness (0..1)
      rotate: 0, // The rotation offset
      color: '#000', // #rgb or #rrggbb
      speed: 0.8, // Rounds per second
      trail: 45, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: false, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
      top: 'auto', // Top position relative to parent in px
      left: 'auto' // Left position relative to parent in px
    }
  };

  Besko.Views.LoadingAnimation = Support.CompositeView.extend({
    initialize: function(options) {
      var view = this,
          resource = this.collection || this.model;

      this.version = options.version || 'small';

      if ( resource ) {
        this.listenTo(resource, 'sync reset', function() {
          view.$el.hide();
        });

        this.listenTo(resource, 'request', function() {
          view.$el.show();
        });

        this.$el.hide();
      }
    },

    render: function() {
      var options = spinnerOptions[this.version];
      new Spinner(options).spin(this.el);

      return this;
    }
  });
})();
