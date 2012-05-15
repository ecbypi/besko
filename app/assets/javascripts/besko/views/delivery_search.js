(function() {
  var templates, helpers, DeliverySearch, DeliveryDetails;

  templates = {
    deliveries: _.template('\
      <h2 class="current-date">\
        <input name="delivered_on" disabled="true" />\
      </h2>\
      \
      <button class="prev">Previous Day</button>\
      <button class="next">Next Day</button>\
      \
      <table data-collection="deliveries">\
        <thead>\
          <tr>\
            <th>Delivered At</th>\
            <th>Received By</th>\
            <th>Delivered By</th>\
            <th>Total Packages</th>\
          </tr>\
        </thead>\
      </table>'),

    delivery: _.template('\
      <tr class="delivery-details">\
        <td><%= escape("delivered_at") %></td>\
        <td><a href="mailto:<%= worker.escape("email") %>"><%= worker.name() %></a></td>\
        <td><%= escape("deliverer") %></td>\
        <td><%= escape("package_count") %></td>\
      </tr>'),

    receipt: _.template('\
      <tr class="receipt-details" data-resource="receipt">\
        <td></td>\
        <td><%= recipient.name() %></td>\
        <td><%= escape("comment") %></td>\
        <td><%= escape("number_packages") %></td>\
      </tr>')
  };

  helpers = {
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
      }).val(view.date.strftime(this.dateFormat));

      view.$datepicker = $datepicker;
    },
  };

  DeliveryDetails = Support.CompositeView.extend({
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

  DeliverySearch = Support.CompositeView.extend({
    className: 'deliveries',
    events: {
      'click button.next' : 'next',
      'click button.prev' : 'prev'
    },

    initialize: function(options) {
      this.date = Besko.Date(options.date);
      _.bindAll(this, '_leaveChildren');
      _.bindAll(this, 'renderDeliveries');
      this.collection.bind('reset', this._leaveChildren);
      this.collection.bind('reset', this.renderDeliveries);
    },

    render: function() {
      this.$el.html(templates.deliveries());
      helpers.initializeDatepicker(this);
      this.renderDeliveries();
      return this;
    },

    renderDeliveries: function() {
      var $el = this.$('thead'),
          view = this,
          subview;

      this.collection.each(function(delivery) {
        subview = new DeliveryDetails({ model: delivery });
        view.renderChild(subview);

        $el.after(subview.el);
        $el = subview.$el;
      });
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
