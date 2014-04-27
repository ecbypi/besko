/* global Support, Routes, Cookies */
(function() {
  'use strict';

  var Receipt = Support.CompositeView.extend({
    tagName: 'tr',

    events: {
      'click [data-remove]' : 'leave'
    },

    render: function() {
      if ( this.$el.is(':empty') ) {
        var view = this;

        $.ajax({
          url: Routes.new_receipt_path(),
          data: { user_id: this.model.id },
          dataType: 'html'
        }).then(function(markup) {
          var $markup = $(markup);

          view.$el.replaceWith($markup);
          view.setElement($markup);
        }, function() {
          Besko.error('Failed to add recipient ' + view.model.escape('name') + '.');
        });
      }
    },

    incrementPackageCount: function() {
      var currentCount;

      if ( !this.$input ) {
        this.$input = this.$('input[type=number]');
      }

      currentCount = parseInt(this.$input.val(), 10);

      this.$input.val(currentCount + 1);
    },

    leave: function() {
      this.trigger('leave', this);
      Support.CompositeView.prototype.leave.apply(this);

      return false;
    }
  });

  Besko.Views.DeliveryForm = Support.CompositeView.extend({
    events: {
      'click [data-reset]' : 'reset',
      'submit' : 'validate'
    },

    initialize: function() {
      this.$deliverer = this.$('#delivery_deliverer');
      this.$table = this.$('[data-collection=receipts]').parent();

      this.listenTo(this.collection, 'add', this.addReceipt);
      this.listenTo(this.collection, 'add', this.hideShowTable);
      this.listenTo(this.collection, 'remove', this.hideShowTable);
      this.listenTo(this.collection, 'reset', this.hideShowTable);
      this.listenTo(this.collection, 'add', this.updateCookie);
      this.listenTo(this.collection, 'remove', this.updateCookie);
      this.listenTo(this.collection, 'reset', this.updateCookie);
    },

    render: function() {
      var view = this, receipt, recipient, recipientId;

      this.$('[data-resource=receipt]').each(function() {
        recipientId = parseInt($(this).find('input[type=hidden]').val(), 10);

        recipient = new Backbone.Model({ id: recipientId });
        view.collection.add(recipient, { silent: true });

        receipt = new Receipt({ model: recipient, el: this });

        view.listenToOnce(receipt, 'leave', view.removeReceipt);
        view.renderChild(receipt);
      });

      this.search = new Besko.Views.AutocompleteSearch({
        el: $('[data-recipient-search]'),
        collection: new Besko.Collections.Users()
      });

      this.listenTo(this.search, 'select', this.addRecipient);
      this.search.render();

      return this;
    },

    hideShowTable: function() {
      if ( this.collection.isEmpty() ) {
        this.$table.removeClass('open');
      } else {
        this.$table.addClass('open');
      }
    },

    addRecipient: function(model) {
      if ( model.id ) {
        if ( this.collection.get(model) ) {
          var view = this.children.find(function(child) {
            return child.model.id === model.id;
          });

          view.incrementPackageCount();
        } else {
          this.collection.add(model);
        }

        this.search.reset();
      } else {
        var collection = this.collection;

        model.on('sync', function(recipient) {
          collection.add(recipient);
        });

        model.on('error', function(recipient) {
          Besko.error('Failed to add recipient ' + recipient.escape('name') + '.');
        });

        this.search.listenToOnce(model, 'sync error', this.search.reset);

        model.save();
      }
    },

    addReceipt: function(model) {
      var receipt = new Receipt({ model: model });

      this.listenToOnce(receipt, 'leave', this.removeReceipt);
      this.appendChildTo(receipt, '[data-collection=receipts]');
    },

    removeReceipt: function(receipt) {
      this.collection.remove(receipt.model);
    },

    validate: function() {
      if ( !this.$deliverer.val() ) {
        Besko.error('A deliverer is required to log a delivery.');
        return false;
      }

      if ( this.collection.isEmpty() ) {
        Besko.error('At least one recipient is required.');
        return false;
      }
    },

    reset: function() {
      this.$deliverer.val('');

      this.children.each(function(child) {
        child.leave();
      });

      this.collection.reset();

      this.search.reset();

      return false;
    },

    updateCookie: function() {
      var recipientIds = this.collection.map(function(recipient) {
        return recipient.id;
      });

      Cookies.set('delivery_recipients', recipientIds);
    }
  });
})();
