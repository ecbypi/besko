(function() {
  DeliveryForm = Support.CompositeView.extend({
    events: {
      'click a[data-clear]' : 'clear',
      'keydown #user-search' : function(event) {
        if ( event.keyCode === 13 ) {
          event.preventDefault();
        }
      },
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
      var view = this;

      this.$receipts = this.$('[data-collection=receipts]');
      this.$headerAndFooter = this.$('thead, tfoot');
      this.$select = this.$('#delivery_deliverer');

      this.$('#user-search').autocomplete({
        source: '/users.json?autocomplete=true',
        select: function(event, ui) {
          delete ui.item.value;
          delete ui.item.label;
          delete ui.item.name;

          if ( ui.item.id ) {
            var data = { user_id: ui.item.id };
          } else {
            delete ui.item.id;
            var data = { user: ui.item };
          }

          $.ajax({
            url: '/receipts/new',
            data: data,
            dataType: 'script',
            success: function(data, response, textStatus) {
              var el = view.$receipts.children('[data-resource=receipt]:last'),
                  fields = new ReceiptFields();

              fields.setElement(el);

              view.$headerAndFooter.show();
              view.renderChild(fields);
            }
          });
        }
      });
    },

    render: function() {
      return this;
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
      this.hideTable();
    },

    hideTable: function() {
      if ( !this.$receipts.children().length ) {
        this.$headerAndFooter.hide();
      }
    }
  })

  ReceiptFields = Support.CompositeView.extend({
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
