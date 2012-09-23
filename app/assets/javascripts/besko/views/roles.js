(function() {
  var Roles = Support.CompositeView.extend({
    events: {
      'change select' : function(event) {
        var title = $(event.target).val(),
            path = '/admin/roles';

        if ( title ) {
          path = path + '?title=' + title;
        }

        window.history.pushState({}, 'Besko | Role Management', path);
        this.fetch(title);
      }
    },

    initialize: function(options) {
      this.collection.on('reset', this.render, this);
      this.collection.on('reset', this.toggleRolesList, this);
      this.collection.on('add', this.render, this);
      this.collection.on('add', this.toggleRolesList, this);

      this.$roles = this.$('[data-collection=user_roles]');

      if ( options.title ) {
        this.fetch(options.title);
      }

      this.form = new Form({
        el: document.getElementById('new_user_role'),
        collection: this.collection
      });
    },

    fetch: function(title) {
      this.collection.fetch({
        data: { title: title }
      });
    },

    toggleRolesList: function() {
      if ( this.collection.length ) {
        this.$roles.show();
      } else {
        this.$roles.hide();
      }
    },

    render: function() {
      var view = this,
          $roles = this.$roles.find('tbody').empty();

      this.collection.each(function(role) {
        var role = new Role({
          model: role,
          collection: view.collection
        });
        view.renderChild(role);
        $roles.append(role.el);
      });

      return this;
    }
  });

  var Role = Support.CompositeView.extend({
    tagName: 'tr',

    attributes: {
      'data-resource' : 'user_role'
    },

    events: {
      'click button' : function(event) {
        var view = this;

        if ( confirm(this.confirmationMessage()) ) {
          this.model.destroy({
            wait: true,

            success: function(model, response) {
              view.collection.remove(this.model);
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
      }
    },

    template: _.template('\
      <td><%= escape("name") %></td>\
      <td><%= escape("added") %></td>\
      <td><button>Remove</button></td>'),

    render: function() {
      this.$el.html(this.template(this.model));
    },

    confirmationMessage: function() {
      return 'Remove ' + this.model.get('name') +
        ' from ' + this.model.get('title') + 's?';
    }
  });

  var Form = Support.CompositeView.extend({
    events: {
      'ajax:before' : function(event) {
        if ( !this.$select.val() ) {
          Besko.Support.error('Select a role before adding a user.');
          return false;
        }

        if ( !this.$user.val() ) {
          Besko.Support.error('You need to find a user in order to add them to the selected role.');
          return false;
        }
      },

      'ajax:error' : function(event, xhr, status, error) {
        Besko.Support.error('User is already in the selected role.');
      },

      'ajax:success' : function(event, data, status, xhr) {
        Besko.Support.notice(data.name + ' is now a ' + data.title);
        this.collection.add(data, { at: 0 });

        // Reset form
        this.$user.val('');
        this.$search.val('');
      }
    },

    initialize: function(options) {
      this.$select = this.$('#user_role_title');
      this.$user = this.$('#user_role_user_id');
      this.$search = this.$('#user-search');

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
