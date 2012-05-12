(function() {
  var logins, editors, deliveryCompanies, schemas, templates, helpers, DeliveryForm, ReceiptForm;

  logins = _([]);
  editors = Backbone.Form.editors;
  deliverers = _([
    '',
    'UPS',
    'USPS / Post Office',
    'FedEx',
    'LaserShip',
    'Amazon',
    'DHL',
    'Interdepartmental',
    'Laundry Service',
    'Student / Personal',
    'Other',
    'Unavailable'
  ]).map(function(company) {
    return { val: company, label: company };
  });

  schemas = {
    deliverer: {
      title: 'Delivery Company',
      type: 'Select',
      validators: ['required'],
      options: deliverers,
      editorClass: 'select input required',
      fieldClass: 'select required',
      help: 'usually on package label'
    },

    receipt: {
      recipient_id: {
        fieldClass: 'hidden required',
        editorAttrs: {
          type: 'hidden'
        },
        validators: ['required']
      },
      number_packages: {
        dataType: 'number',
        title: 'Number of Packages',
        fieldClass: 'number required',
        editorClass: 'number required',
        editorAttrs: {
          min: 1
        },
        validators: ['required']
      },
      comment: {
        type: 'TextArea',
        title: 'Comments',
        fieldClass: 'text optional'
      }
    }
  };

  templates = {
    receipt: _.template('\
        <td><%= name() %></td>\
        <td> class="input number required"></td>\
        <td> class="input text optional"></td>\
        <td><button data-cancel>Remove</button></td>'),

    delivery: _.template('\
      <section class="inputs">\
        <div class="input select required">\
          <label for="deliverer" class="select required">Delivery Company</label>\
          <div class="hint"></div>\
          <div class="error"></div>\
        </div>\
        \
        <div class="input search">\
          <label class="search" for="user-search">Search</label>\
          <input id="user-search" name="search" type="search" autofocus placeholder="Enter name, email or kerberos"/>\
        </div>\
      </section>\
      \
      <table class="receipts" data-collection="receipts">\
        <thead>\
          <tr>\
            <th>Recipient</th>\
            <th>Number of Packages</th>\
            <th>Comment</th>\
            <th></th>\
          </tr>\
        </thead>\
        <tbody></tbody>\
        <tfoot>\
          <tr>\
            <td></td>\
            <td><button data-role="commit">Send Notifications</button></td>\
            <td><button data-role="cancel">Cancel</button></td>\
            <td></td>\
          </tr>\
        </tfoot>\
      </table>')
  };

  helpers = {
    setupAutocomplete: function(view) {
      var $el = view.$('#user-search');

      // Stop if we've already setup the autocomplete
      if ( $el.hasClass('ui-autocomplete-input') ) return;

      $el.autocomplete({
        source: '/users?autocomplete=true',
        select: function(event, ui) {
          delete ui.item.value;
          delete ui.item.label;

          // Only add recipient if they haven't been added yet
          if ( !logins.include(ui.item.login) ) {
            logins.push(ui.item.login);

            receipt = new Besko.Models.Receipt({recipient: ui.item});
            receiptForm = new ReceiptForm({model: receipt});

            view.toggleHeaderFooter();
            view.renderChild(receiptForm);
            view.$('tbody').append(receiptForm.el);

          } else {
            Besko.Support.error('Already added this recipient. Increment the number of packages they received.');
          }
        }
      });
    },

    addDelivererEditor: function(view, schema) {
      schema = schema || schemas.deliverer;

      if ( typeof view.deliverer !== 'undefined' ) view.deliverer.remove();

      view.deliverer = new editors[schema.type]({
        model: view.model,
        schema: schema,
        key: 'deliverer',
        type: schema.type,
        id: 'deliverer'
      }).render();

      view.$deliverer = view.$('div.input.select')
        .find('label')
        .after(view.deliverer.el).end();
    },

    createReceiptEditors: function(model) {
      var createEditor = Backbone.Form.helpers.createEditor,
          editors = {};

      _(schemas.receipt).map(function(schema, key) {
        options = {
          key: key,
          type: schema.type || 'Text',
          model: model,
          schema: schema
        };
        editors[key] =  createEditor(options.type, options).render();
      });

      return editors;
    }
  };

  DeliveryForm = Support.CompositeView.extend({
    className: 'new-delivery',
    tagName: 'section',
    attributes: {
      'data-resource': 'delivery'
    },

    events: {
      'click button[data-role=commit]' : 'commit',
      'click button[data-role=cancel]' : 'reset',
      'change select#deliverer' : 'swapDelivererEditor',
      'click button[data-cancel]' : 'toggleHeaderFooter'
    },

    render: function() {
      this.$el.html(templates.delivery());
      helpers.setupAutocomplete(this);
      helpers.addDelivererEditor(this);
      return this;
    },

    swapDelivererEditor: function(event) {
      if ( $(event.target).val() === 'Other' ) {
        var schema = _(schemas.deliverer).extend({
          type: 'Text',
          editorClass: 'input string required',
          editorAttrs: {
            autofocus: '',
            placeholder: 'Enter name of deliverer'
          }
        });
        helpers.addDelivererEditor(this, schema);
      }
    },

    toggleHeaderFooter: function(event) {
      var $els = this.$('thead, tfoot'),
          size = this.children.size();

      if ( typeof size !== 'number' ) size = size.value();
      if ( ( event && $(event.target).is('button') ) || size === 0 ) $els.toggle();
    },

    commit: function() {
      var error, receiptAttributes;

      // Validate deliverer
      if ( (error = this.deliverer.commit()) ) {
        this.$deliverer.addClass('field_with_errors');
        this.$deliverer.find('.error').text(error.message);
        return false;
      }

      // Validate receipts
      receiptAttributes = this.children.map(function(receipt) {
        _(receipt.editors).each(function(editor, key) {
          if ( editor.commit() ) return false;
        });
        return receipt.model.attributes;
      });

      // Insert receipts to be associated with the delivery
      this.model.receipts.reset(receiptAttributes);

      // Save if everything is valid
      this.model.save({}, {
        success: function(model, response) {
          Besko.Support.notice('Notifications Sent');
        },
        error: function(model, response) {
          Besko.Support.error('There was a problem saving this delivery.');
          return false;
        }
      });

      // Cleanup if everything went okay
      this.reset();
    },

    reset: function() {
      this._leaveChildren();
      this.model = new Besko.Models.Delivery({});
      this.toggleHeaderFooter();
      helpers.addDelivererEditor(this);
      logins = _([]);
    }
  })

  ReceiptForm = Support.CompositeView.extend({
    tagName: 'tr',
    className: 'inputs',
    attributes: {
      'data-resource': 'receipt'
    },

    events: {
      'click button[data-cancel]': 'clear'
    },

    render: function() {
      this.editors = helpers.createReceiptEditors(this.model);
      this.$el.html(templates.receipt(this.model.recipient));
      this.$('td:nth-child(2)').html(this.editors.number_packages.el);
      this.$('td:nth-child(3)').html(this.editors.comment.el);
      return this;
    },

    clear: function() {
      logins.pop(this.model.recipient.get('login'));
      this.leave();
    }
  })

  Besko.Views.DeliveryForm = DeliveryForm;
})();
