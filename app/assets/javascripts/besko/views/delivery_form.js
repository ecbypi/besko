(function() {
  var DeliveryForm = Support.CompositeView.extend({
    events: {
      'click [data-cancel]' : 'clear',

      'ajax:before' : 'validate',
      'ajax:failure' : function(event, xhr, status, error) {
        Besko.Support.error('Unable to log this delivery.')
      },
      'ajax:success' : function(event) {
        Besko.Support.notice('Notifications Sent.');
        this.clear();
      }
    },

    initialize: function(options) {
      this.search = new Besko.Views.UserAutocomplete;
      this.search.render();

      this.search.on('select', this.addRecipient, this);
      this.$('.input.select').after(this.search.el);

      this.receipts = new Receipts({ el: document.getElementById('receipts-attributes') });

      this.$select = this.$('#delivery_deliverer');
    },

    addRecipient: function(model) {
      if ( model.id ) {
        var data = { user_id: model.id };
      } else {
        var data = { user: model.attributes };
      }

      $.ajax({
        url: '/receipts/new',
        data: data,
        dataType: 'script'
      });
    },

    validate: function(event) {
      if ( !this.$select.val() ) {
        Besko.Support.error('A deliverer is required to log a delivery.');
        return false;
      }

      if ( this.receipts.empty() ) {
        Besko.Support.error('At least on recipient is required for a delivery.');
        return false;
      }
    },

    clear: function(event) {
      this.$select.val('');
      this.receipts.reset();
    },
  })

  var Receipts = Backbone.View.extend({
    events: {
      'click [data-resource=receipt]' : 'removeReceipt'
    },

    initialize: function(options) {
      this.$receipts = this.$('[data-collection=receipts]');
    },

    empty: function() {
      return !this.$receipts.children().length;
    },

    hideTable: function(event) {
      if ( this.empty() ) {
        this.$el.hide();
      }
    },

    removeReceipt: function(event) {
      var $target = $(event.target);

      if ( $target.is('a') ) {
        $target.parents('[data-resource=receipt]').remove();
        this.hideTable();
      }
    },

    reset: function() {
      this.$receipts.empty();
      this.$el.hide();
    }
  });

  Besko.Views.DeliveryForm = DeliveryForm;
})();
