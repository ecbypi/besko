(function() {
  var DeliveryForm = Support.CompositeView.extend({
    events: {
      'click a[data-cancel]' : 'clear',
      'click [data-resource=receipt]' : 'removeReceipt',

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
      this.$receipts = this.$('[data-collection=receipts]');
      this.$table = this.$('#receipts-attributes');
      this.$select = this.$('#delivery_deliverer');
    },

    render: function() {
      this.search = new Besko.Views.UserAutocomplete;
      this.$('.input.select').after(this.search.render().el);
      this.bindTo(this.search, 'select', this.addRecipient);

      return this;
    },

    addRecipient: function(model) {
      var view = this;

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

    removeReceipt: function(event) {
      var $target = $(event.target);

      if ( $target.is('a') ) {
        $target.parents('[data-resource=receipt]').remove();
        this.hideTable();
      }
    },

    validate: function(event) {
      if ( !this.$select.val() ) {
        Besko.Support.error('A deliverer is required to log a delivery.');
        return false;
      }

      if ( !this.$receipts.children().length ) {
        Besko.Support.error('At least on recipient is required for a delivery.');
        return false;
      }
    },

    clear: function(event) {
      this.$receipts.empty();
      this.$select.val('');
      this.$table.hide();
    },

    hideTable: function() {
      if ( !this.$receipts.children().length ) {
        this.$table.hide();
      }
    }
  })

  Besko.Views.DeliveryForm = DeliveryForm;
})();
