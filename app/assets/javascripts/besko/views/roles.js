(function() {
  var template = _.template('\
    <tr data-resource="user_role">\
      <td><%= escape("name") %></td>\
      <td><%= escape("added") %></td>\
      <td></td>\
    </tr>');

  var Roles = Support.CompositeView.extend({
    events: {
      'change select' : function(event) {
        var title = $(event.target).val();

        this.collection.fetch({
          data: { title: title }
        });
      }
    },

    initialize: function(options) {
      this.collection.on('reset', this.render, this);
    },

    render: function() {
      var $roles = this.$('[data-collection=user_roles]').empty();

      this.collection.each(function(role) {
        $roles.append(template(role));
      });

      return this;
    }
  });

  Besko.Views.RoleManagement = Roles;
})();
