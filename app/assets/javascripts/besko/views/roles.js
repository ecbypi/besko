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
      this.collection.on('add', this.render, this);

      this.form = new Form({
        el: document.getElementById('new_user_role'),
        collection: this.collection
      });
    },

    render: function() {
      var $roles = this.$('[data-collection=user_roles]').empty();

      this.collection.each(function(role) {
        $roles.append(template(role));
      });

      return this;
    }
  });

  var Form = Support.CompositeView.extend({
    events: {
      'ajax:success' : function(event, data, status, xhr) {
        Besko.Support.notice(data.name + ' is now a ' + data.title);
        this.collection.add(data, { at: 0 });

        // Reset form
        this.$user.val('');
      }
    },

    initialize: function(options) {
      this.$select = this.$('#user_role_title');
      this.$user = this.$('#user_role_user_id');

      this.$('#user-search').autocomplete({
        source: '/users.json?options[local_only]=true',
        select: function(event, ui) {
          $(this).siblings('input[type=hidden]').val(ui.item.id);
        }
      });
    }
  });

  Besko.Views.RoleManagement = Roles;
})();
