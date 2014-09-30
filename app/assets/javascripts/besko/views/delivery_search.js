/* global Support */
(function() {
  "use strict";

  var categoryToCollection = {
    desk_worker: 'DeskWorkers',
    recipient: 'Recipients'
  };

  Besko.Views.DeliverySearch = Support.CompositeView.extend({
    events: {
      'change select' : 'filterDeliveries'
    },

    initialize: function() {
      this.pjaxContainerSelector = '[data-pjax-container]';
    },

    render: function() {
      this.$el.pjax('[data-pjax]', this.pjaxContainerSelector);

      var view = this;
      this.$('[data-autocomplete-input]').each(function() {
        var searchView,
            $search = $(this),
            constructorName = categoryToCollection[$search.data('category')],
            constructor = Besko.Collections[constructorName],
            collection = new constructor();

        searchView = new Besko.Views.AutocompleteSearch({
          el: this,
          collection: collection
        });

        function updateInputFromAutocomplete(model) {
          searchView.$('input[type=hidden]').val(model.id);
          view.filterDeliveries();
        }

        function resetInputFromAutocomplete() {
          searchView.$('input[type=hidden]').val('');
          view.filterDeliveries();
        }

        view.listenTo(searchView, 'select', updateInputFromAutocomplete);
        view.listenTo(searchView, 'reset', resetInputFromAutocomplete);

        view.renderChild(searchView);
      });

      return this;
    },

    filterDeliveries: function() {
      $.pjax({
        url: this.el.action,
        data: this.$el.serializeArray(),
        container: this.pjaxContainerSelector
      });
    }
  });
})();
