(function() {
  DeliveryForm = Support.CompositeView.extend({
    events: {
      'click a[data-clear]' : 'clear'
    },

    initialize: function(options) {
      var view = this;

      this.$tbody = this.$('tbody');
      this.$headerAndFooter = this.$('thead, tfoot');

      this.$('#user-search').autocomplete({
        source: '/users?autocomplete=true',
        select: function(event, ui) {
          delete ui.item.value;
          delete ui.item.label;

          if ( ui.item.id ) {
            var data = { user_id: ui.item.id };
          } else {
            var data = { user: ui.item };
          }

          $.ajax({
            url: '/receipts/new',
            data: data,
            dataType: 'script',
            success: function(data, response, textStatus) {
              var el = view.$tbody.children().last()[0],
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

    clear: function(event) {
      this._leaveChildren();
      this.$('select#delivery_deliverer').val('');
      this.$el.validate();
      this.hideTable();
    },

    hideTable: function() {
      if ( this.$tbody.children().length === 0 ) {
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
