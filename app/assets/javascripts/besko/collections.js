(function() {
  var Collections = {
    Users: Backbone.Collection.extend({
      url: '/users',
      model: Besko.Models.User
    }),

    Deliveries: Backbone.Collection.extend({
      url: '/deliveries',
      model: Besko.Models.Delivery
    }),

    Receipts: Backbone.Collection.extend({
      url: '/receipts',
      model: Besko.Models.Receipt
    }),

    UserRoles: Backbone.Collection.extend({
      url: '/admin/roles',
      model: Besko.Models.UserRole
    })
  };

  Besko.Collections = Collections;
})();
