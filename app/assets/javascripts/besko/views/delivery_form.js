/* global Support, Routes */
(function() {
  'use strict';

  function updateState(view) {
    window.history.replaceState(
      view.recipients,
      document.title,
      Routes.new_delivery_path({ r: view.recipients })
    );
  }

  Besko.Views.DeliveryForm = Support.CompositeView.extend({
    events: {
      'click [data-reset]' : 'reset',
      'click [data-remove]' : 'removeReceipt',
      'input input[type=number]' : 'incrementUrlPackageCount',
      'submit' : 'validate'
    },

    initialize: function(options) {
      this.$deliverer = this.$('#delivery_deliverer');
      this.$receipts = this.$('[data-collection=receipts]');
      this.recipients = options.recipients;

      _.bindAll(this, 'addRecipient');
    },

    render: function() {
      this.search = new Besko.Views.AutocompleteSearch({
        el: $('[data-recipient-search]'),
        collection: new Besko.Collections.Users(),
        onSelect: function(searchView, model) {
          searchView.input.$el.val('');
        }
      });

      this.listenTo(this.search, 'select', this.addRecipient);
      this.search.render();

      return this;
    },

    hideShowTable: function() {
      if ( this.$receipts.children().length ) {
        this.$el.addClass('open');
      } else {
        this.$el.removeClass('open');
      }
    },

    addRecipient: function(recipient) {
      if ( recipient.id ) {
        if ( this.recipients[recipient.id] ) {
          this.incrementPackageCount(recipient);
        } else {
          this.addReceipt(recipient);
        }
      } else {
        var view = this;

        recipient.save().then(function() {
          view.addReceipt(recipient);
        }, function() {
          Besko.error('Failed to add recipient ' + recipient.escape('name') + '.');
        });
      }
    },

    addReceipt: function(recipient) {
      var view = this;

      $.ajax({
        url: Routes.new_receipt_path(),
        data: { user_id: recipient.id },
        dataType: 'html'
      }).then(function(markup) {
        view.$receipts.append(markup);
        view.hideShowTable();
        view.recipients[recipient.id] = 1;

        updateState(view);
      }, function() {
        Besko.error('Failed to add recipient ' + recipient.escape('name') + '.');
      });
    },

    removeReceipt: function(event) {
      var $receipt = $(event.target).parents('[data-resource=receipt]'),
          recipientId = $receipt.data('recipient');

      delete this.recipients[recipientId];
      $receipt.remove();
      this.hideShowTable();
      updateState(this);

      return false;
    },

    validate: function() {
      if ( !this.$deliverer.val() ) {
        Besko.error('A deliverer is required to log a delivery.');
        return false;
      }

      if ( !this.$receipts.children().length ) {
        Besko.error('At least one recipient is required.');
        return false;
      }
    },

    reset: function() {
      this.$deliverer.val('');

      this.$receipts.empty();
      this.hideShowTable();
      this.search.reset();
      this.recipients = {};

      updateState(this);

      return false;
    },

    incrementPackageCount: function(recipient) {
      var $receipt = this.$receipts.find('[data-recipient=' + recipient.id + ']'),
          $input = $receipt.find('input[type=number]'),
          recipientId = $receipt.data('recipient');

      this.recipients[recipientId] += 1;
      $input.val(this.recipients[recipientId]);

      updateState(this);
    },

    incrementUrlPackageCount: function(event) {
      var $input = $(event.target),
          $receipt = $input.parents('[data-resource=receipt]'),
          recipientId = $receipt.data('recipient');

      this.recipients[recipientId] = $input.prop('value');
      updateState(this);
    }
  });
})();
