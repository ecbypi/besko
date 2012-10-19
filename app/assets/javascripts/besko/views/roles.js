(function() {
  var RoleManagement = Support.CompositeView.extend({
    initialize: function(options) {
      this.form = new Form({
        el: document.getElementById('new_user_role'),
        collection: this.collection
      });

      this.roles = new Roles({
        el: document.getElementById('roles'),
        collection: this.collection
      }).render();
    }
  });

  var Roles = Support.CompositeView.extend({
    initialize: function(options) {
      this.collection.on('reset', this.render, this);
      this.collection.on('add', this.render, this);

      this.$roles = this.$('[data-collection=user_roles]');
      this.$thead = this.$('thead');
    },

    render: function() {
      var view = this;
      this._leaveChildren();

      if ( this.collection.length ) {
        this.collection.each(function(role) {
          var role = new Role({ model: role });

          view.renderChild(role);
          view.$roles.append(role.el);
        });

        this.$thead.show();
      } else {
        this.$thead.hide();
      }

      return this;
    }
  });

  var Role = Support.CompositeView.extend({
    tagName: 'tr',

    attributes: {
      'data-resource' : 'user_role'
    },

    events: {
      'click button' : 'clear'
    },

    template: _.template('\
      <td class="user-role-name"><%= escape("name") %></td>\
      <td class="date-added"><%= escape("added") %></td>\
      <td><button>Remove</button></td>'),

    render: function() {
      this.$el.html(this.template(this.model));
    },

    clear: function(event) {
      var view = this;

      if ( confirm(this.confirmationMessage()) ) {
        this.model.destroy({
          wait: true,

          success: function(model, response) {
            view.parent.collection.remove(this.model);
            view.leave();

            Besko.Support.notice(
              model.escape('name') + ' is no longer a ' +
              model.escape('title')
            );
          },

          error: function(model, response) {
            Besko.Support.error(
              'Unable to remove ' + model.escape('name') +
              ' from ' +  model.escape('title') +
              '. Refresh the page and try again.'
            );
          }
        });
      }
    },

    confirmationMessage: function() {
      return 'Remove ' + this.model.get('name') +
        ' from ' + this.model.get('title') + 's?';
    }
  });

  var Form = Support.CompositeView.extend({
    events: {
      'keydown input' : function(event) {
        if ( event.keyCode === 13 ) {
          event.preventDefault();
        }
      },
      'change select' : 'fetch',
      'ajax:before' : 'validate',
      'ajax:success' : 'updateCollection',
      'ajax:error' : function(event, xhr, status, error) {
        Besko.Support.error('User is already in the selected role.');
      }
    },

    initialize: function(options) {
      this.$select = this.$('#user_role_title');
      this.$user = this.$('#user_role_user_id');

      new Besko.Views.UserSearch({
        local: true,
        context: this,
        select: this.submit
      });
    },

    submit: function(view, event, ui) {
      view.$('#user_role_user_id').val(ui.item.id);

      view.$el.submit();
    },

    validate: function(event) {
      if ( !this.$select.val() ) {
        Besko.Support.error('Select a role before adding a user.');
        return false;
      }

      if ( !this.$user.val() ) {
        Besko.Support.error('You need to find a user in order to add them to the selected role.');
        return false;
      }
    },

    fetch: function(event) {
      var title = $(event.target).val(),
          path = '/admin/roles';

      if ( title ) {
        path = path + '?title=' + title;
      }

      window.history.pushState({}, 'Besko | Role Management', path);

      this.collection.fetch({
        data: { title: title }
      });
    },

    updateCollection: function(event, data, status, xhr) {
      Besko.Support.notice(data.name + ' is now a ' + data.title);
      this.collection.add(data, { at: 0 });

      // Reset form
      this.$user.val('');
    }
  });

  Besko.Views.RoleManagement = RoleManagement;
})();
