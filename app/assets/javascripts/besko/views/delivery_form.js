(function() {
  var templates = {
    result: _.template('\
      <li>\
        <a>\
          <%- name %>\
          <span class="autocomplete-result-details">\
            <%- details %>\
          </span>\
        </a>\
      </li>')
  };

  var DeliveryForm = Support.CompositeView.extend({
    events: {
      'click a[data-cancel]' : 'clear',
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
      this.$headerAndFooter = this.$('thead, tfoot');
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
        dataType: 'script',
        success: function(data, response, textStatus) {
          var el = view.$receipts.children('[data-resource=receipt]:last'),
              fields = new ReceiptFields({ el: el });

          view.$headerAndFooter.show();
          view.renderChild(fields);
        }
      });
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
      this._leaveChildren();
      this.$select.val('');
      this.$headerAndFooter.hide();
    },

    hideTable: function() {
      if ( !this.$receipts.children().length ) {
        this.$headerAndFooter.hide();
      }
    }
  })

  var ReceiptFields = Support.CompositeView.extend({
    events: {
      'click a': 'clear'
    },

    render: function() {
      return this;
    },

    clear: function() {
      this.leave();
      this.parent.hideTable();
    }
  })

  Besko.Views.DeliveryForm = DeliveryForm;
})();
