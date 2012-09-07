(function() {
  var templates = {
    delivery: _.template('\
      <tr class="delivery-details">\
        <td class="delivered-at"><%= escape("delivered_at") %></td>\
        <td class="received-by"><a href="mailto:<%= worker.escape("email") %>"><%= worker.name() %></a></td>\
        <td class="delivered-by"><%= escape("deliverer") %></td>\
        <td class="package-count"><%= escape("package_count") %></td>\
      </tr>'),

    receipt: _.template('\
      <tr class="receipt-details" data-resource="receipt">\
        <td></td>\
        <td><%= recipient.name() %></td>\
        <td><%= escape("comment") %></td>\
        <td><%= escape("number_packages") %></td>\
      </tr>')
  };

  var helpers = {
    dateFormat: '%A, %B %d, %Y',

    initializeDatepicker: function(view) {
      var $datepicker = view.$('input[name=delivered_on]');

      $datepicker.datepicker({
        minDate: 'Tuesday, October 19, 2010',
        maxDate: Besko.Date().strftime(this.dateFormat),
        dateFormat: 'DD, MM dd, yy',
        changeMonth: true,
        changeYear: true,
        selectOtherMOnths: true,
        showOtherMonths: true,
        onSelect: function(dateText, options) {
          view.fetch(Besko.Date(dateText));
        },
        buttonText: 'Change',
        showOn: 'button',
        autosize: true,
        hideIfNoPrevNext: true
      });

      view.$datepicker = $datepicker;
    },
  };

  var DeliveryDetails = Support.CompositeView.extend({
    tagName: 'tbody',
    className: 'delivery',
    attributes: {
      'data-resource' : 'delivery'
    },

    events: {
      'click' : 'toggleReceipts'
    },

    render: function() {
      this.$el.html(templates.delivery(this.model));
      this.renderReceipts();
      return this;
    },

    renderReceipts: function() {
      var view = this;

      this.model.receipts.each(function(receipt) {
        view.$el.append(templates.receipt(receipt));
      });
    },

    toggleReceipts: function(event) {
      var $target = $(event.target);

      if ( !$target.is('a') ) {
        this.$('.receipt-details').toggle();
        this.$el.toggleClass('open');
      }
    }
  });

  var DeliverySearch = Support.CompositeView.extend({
    className: 'deliveries',
    events: {
      'click button.next' : 'next',
      'click button.prev' : 'prev'
    },

    initialize: function(options) {
      this.date = Besko.Date(options.date);
      this.collection.on('reset', this._leaveChildren, this);
      this.collection.on('reset', this.renderDeliveries, this);
    },

    render: function() {
      helpers.initializeDatepicker(this);
      this.renderDeliveries();
      return this;
    },

    renderDeliveries: function() {
      var $el = this.$('thead'),
          view = this,
          subview;

      if ( this.collection.size() === 0 ) {
        this.$('tbody.empty').show();
      } else {
        this.$('tbody.empty').hide();
        this.collection.each(function(delivery) {
          subview = new DeliveryDetails({ model: delivery });
          view.renderChild(subview);

          $el.after(subview.el);
          $el = subview.$el;
        });
      }

      return this;
    },

    next: function() {
      this.fetch(this.date.increment());
    },

    prev: function() {
      this.fetch(this.date.decrement());
    },

    fetch: function(date) {
      this.date = date;
      this.$datepicker.val(this.date.strftime(helpers.dateFormat));

      var iso = date.strftime('%Y-%m-%d');

      this.collection.fetch({
        data: {
          date: iso,
        },
        success: function(deliveries, response) {
          window.history.replaceState({}, 'Deliveries - ' + iso, '/deliveries?date=' + iso);
        }
      });
    }
  });

  Besko.Views.DeliverySearch = DeliverySearch;
})();
