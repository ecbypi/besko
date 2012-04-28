(function() {
  var templates, helpers, SignupForm, Account;

  templates = {
    form: _.template('\
      <div class="input search">\
        <label for="user-search">Look yourself up in the MIT directory</label>\
        <input id="user-search" type="search" autofocus placeholder="Enter name, email or kerberos" name="search"/>\
        <button data-role="search">Lookup</button>\
      </div>\
      \
      <table data-collection="users">\
        <thead>\
          <tr>\
            <th>Name</th>\
            <th>Email</th>\
            <th>Kerberos</th>\
            <th>Address</th>\
            <th></th>\
          </tr>\
        </thead>\
        <tbody></tbody>\
      </table>'),

    account: _.template('\
      <td><%= user.escape("name") %></td>\
      <td><%= user.escape("email") %></td>\
      <td><%= user.escape("login") %></td>\
      <td><%= user.escape("street") %></td>\
      <td class="input boolean"><%= helpers.createButton(user) %></td>'),

    confirmationButton: _.template('\
      <div class="input boolean">\
        <input class="boolean" type="checkbox" id="<%= cid %>" />\
        <label class="boolean" for="<%= cid %>">This Is Me</label>\
      </div>\
      <div class="actions">\
        <button disabled="disabled" data-role="commit">Request Account</button>\
      </div>')
  };

  helpers = {
    createButton: function(user) {
      if ( typeof user.id !== 'number' ) {
        return templates.confirmationButton(user);
      } else {
        return 'Account Exists';
      };
    }
  };

  SignupForm = Support.CompositeView.extend({
    tagName: 'section',
    className: 'registration',

    events: {
      'click button[data-role=search]' : 'search',
      'keyup input#user-search' : 'submitSearch',
      'click button[data-role=commit]' : 'render'
    },

    initialize: function(options) {
      _.bindAll(this, '_leaveChildren');
      _.bindAll(this, 'renderUsers');
      this.collection.bind('reset', this._leaveChildren);
      this.collection.bind('reset', this.renderUsers);
    },

    render: function() {
      this.$el.html(templates.form());
      return this;
    },

    submitSearch: function(event) {
      if ( event.keyCode === 13 ) this.search();
    },

    search: function() {
      this.collection.fetch({
        data: {
          term: this.$('#user-search').val()
        },
        error: function(users, request) {
          Notification.error('Error processing your request.');
        }
      });
    },

    renderUsers: function() {
      var $tbody = this.$('tbody'),
          view = this;

      if ( this.collection.size() === 0 ) {
        this.$('thead').hide();
        Notification.error('Your search returned no results.');
      } else {
        this.$('thead').show();

        this.collection.each(function(user) {
          account = new Account({model: user});
          view.renderChild(account);
          $tbody.append(account.el);
        });
      }
    }
  });

  Account = Support.CompositeView.extend({
    tagName: 'tr',
    attributes: {
      'data-resource': 'user'
    },

    events: {
      'click button[data-role=commit]' : 'commit',
      'click input[type=checkbox]' : 'toggleButtonDisability'
    },

    render: function() {
      this.$el.html(templates.account({user: this.model, helpers: helpers}));
      this.$button = this.$('button');
      this.$checkbox = this.$('input');
      return this;
    },

    toggleButtonDisability: function() {
      if ( this.$checkbox.is(':checked') ) {
        this.$button.removeAttr('disabled');
      } else {
        this.$button.attr('disabled', 'disabled');
      }
    },

    commit: function() {
      if ( this.$checkbox.is(':checked') ) {
        return this.model.save({}, {
          success: function(account, response) {
            Notification.notice('An email has been sent requesting approval of your account.');
          },
          error: function(account, response) {
            Notification.error('there was a problem saving you\'re account');
          }
        });
      } else {
        this.$('.error').text('Confirmation must be checked.');
        return false;
      }
    }
  });

  Besko.Views.Account = Account;
  Besko.Views.SignupForm = SignupForm;
})();
