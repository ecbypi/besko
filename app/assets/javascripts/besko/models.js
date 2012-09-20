(function() {
  var loadUser, Models;

  loadUser = function(model, name) {
    name = name || 'user';

    var user, attrs = model.attributes[name];

    if ( typeof attrs === 'undefined' ) {
      return;
    } else if ( attrs instanceof Models.User ) {
      user = attrs;
    } else if ( _.isObject(attrs) ) {
      user = new Models.User(attrs);
    }

    if ( user.isNew() ) user.save();

    delete model.attributes[name];

    model[name] = user;
    model.set(name + '_id', user.id);
  };

  Models = {
    User: Backbone.Model.extend({
      urlRoot: '/users',
      name: function() {
        return this.get('first_name') + ' ' + this.get('last_name');
      }
    }),

    Delivery: Backbone.Model.extend({
      urlRoot: '/deliveries',

      initialize: function(attributes) {
        loadUser(this, 'worker');
        this.receipts = new Besko.Collections.Receipts(attributes.receipts);
      },

      toJSON: function() {
        return {
          delivery: _(this.attributes).extend({ receipts_attributes: this.receipts.toJSON() })
        };
      }
    }),

    Receipt: Backbone.Model.extend({
      urlRoot: '/receipts',
      defaults: {
        number_packages: 1
      },

      initialize: function(attributes) {
        loadUser(this, 'recipient');
      }
    }),

    UserRole: Backbone.Model.extend({
      urlRoot: '/admin/roles',
    })
  };

  Besko.Models = Models;
  Besko.Support.loadUser = loadUser;
})();
