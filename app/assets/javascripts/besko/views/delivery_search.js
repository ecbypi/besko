(function() {
  var templates, helpers, DeliverySearch, Delivery;

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
        \
        <tbody></tbody>\
      </table>'),

    delivery: _.template('\
      <tr data-resource="delivery">\
        <td><%= escape("delivered_at") %></td>\
        <td><a href="mailto:<%= worker.escape("email") %>"><%= worker.name() %></a></td>\
        <td><%= escape("deliverer") %></td>\
        <td><%= escape("package_count") %></td>\
      </tr>')
  };

  helpers = {
    dateFormat: '%A, %B %D, %Y',

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

  DeliverySearch = Support.CompositeView.extend({
    className: 'deliveries',
    events: {
      'click button.next' : 'next',
      'click button.prev' : 'prev'
    },

    initialize: function(options) {
      this.date = Besko.Date(options.date);
      _.bindAll(this, 'renderDeliveries');
      this.collection.bind('reset', this.renderDeliveries);
    },

    render: function() {
      this.$el.html(templates.deliveries());
      helpers.initializeDatepicker(this);
      this.renderDeliveries();
      return this;
    },

    renderDeliveries: function() {
      var $tbody = this.$('tbody').empty(),
          view = this;

      this.collection.each(function(delivery) {
        $tbody.append(templates.delivery(delivery));
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
