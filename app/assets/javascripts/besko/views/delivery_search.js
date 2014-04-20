/* global Cookies, Routes */
(function() {
  "use strict";

  Besko.Views.DeliverySearch = Backbone.View.extend({
    events: {
      'click [data-open-calendar]' : function() {
        this.$datepicker.datepicker('show');
      },
      'click [data-sort]' : function(event) {
        var $target     = $(event.target),
            url         = $target.attr('href'),
            queryString = url.split('?')[1],
            queryObject = $.parseQueryObject(queryString);

        Cookies.set('delivery_sort', queryObject.sort);
      },
      'pjax:send' : function() {
        this.$datepicker.datepicker('destroy');
        this.$datepicker = null;
      },
      'pjax:end' : 'initializeDatepicker'
    },

    initialize: function(options) {
      var params = options.params;

      this.pjaxContainerSelector = '#' + this.el.id;
      _.bindAll(this, 'fetch');

      if ( !params.date ) {
        params.date = new Date().strftime('%Y-%m-%d');
      }

      if ( !params.sort ) {
        params.sort = Cookies.get('delivery_sort') || 'newest';
      }

      if ( !Cookies.get('delivery_sort') ) {
        Cookies.set('delivery_sort', params.sort);
      }

      window.history.replaceState(null, document.title, Routes.deliveries_path(params));
    },

    render: function() {
      this.$el.pjax('[data-pjax]', this.pjaxContainerSelector);
      this.initializeDatepicker();

      return this;
    },

    initializeDatepicker: function() {
      this.$datepicker = this.$('#delivered-on');

      this.$datepicker.datepicker({
        mindate: this.minDate,
        maxDate: new Date().strftime('%a, %b %d, %Y'),
        dateFormat: 'D, M dd, yy',
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        selectOtherMonths: true,
        autosize: true,
        hideIfNoPrevNext: true,
        onSelect: this.fetch
      });
    },

    fetch: function(dateText) {
      var date = new Date(dateText),
          isoDate = date.strftime('%Y-%m-%d');

      $.pjax({
        url: Routes.deliveries_path({ date: isoDate, sort: Cookies.get('delivery_sort') }),
        container: this.pjaxContainerSelector,
      });
    }
  });
})();
