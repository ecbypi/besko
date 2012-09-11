(function() {
  var templates = {
    account: _.template('\
      <td class="name"><%= user.escape("name") %></td>\
      <td class="email"><%= user.escape("email") %></td>\
      <td class="kerberos"><%= user.escape("login") %></td>\
      <td class="address"><%= user.escape("street") %></td>\
      <td class="input boolean"><%= button %></td>'),

    confirmationButton: _.template('\
      <div class="input boolean">\
        <input class="boolean" type="checkbox" id="<%= cid %>" />\
        <label class="boolean" for="<%= cid %>">This Is Me</label>\
      </div>\
      <div class="actions">\
        <button disabled="disabled">Request Account</button>\
      </div>')
  };

  var SignupForm = Support.CompositeView.extend({
    initialize: function(options) {
      this.$ldap = this.$('.ldap-signup');
      this.$local = this.$('.local-signup');

      this.results = new SearchResults({
        el: this.$('.search-results'),
        collection: this.collection
      });

      this.search = new UserSearch({
        el: this.$('.user-search')[0],
        collection: this.collection
      });
    }
  });

  var UserSearch = Support.CompositeView.extend({
    events: {
      'click button' : 'search',
      'keyup #user-search' : 'submitSearch'
    },

    initialize: function(options) {
      this.$input = this.$('#user-search');
    },

    submitSearch: function(event) {
      if ( event.keyCode === 13 ) {
        this.search();
      }
    },

    search: function() {
      this.collection.fetch({
        data: {
          term: this.$input.val()
        },
        error: function(users, request) {
          Besko.Support.error('Error processing your request.');
        }
      });
    }
  });

  var SearchResults = Support.CompositeView.extend({
    initialize: function(options) {
      this.collection.on('reset', this._leaveChildren, this);
      this.collection.on('reset', this.render, this);
    },

    render: function() {
      var $tbody = this.$('tbody'),
          view = this;

      if ( this.collection.length === 0 ) {
        this.$el.hide();
        Besko.Support.error('Your search returned no results.');
      } else {
        this.$el.show();

        this.collection.each(function(user) {
          account = new Account({ model: user });
          view.renderChild(account);
          $tbody.append(account.el);
        });
      }
    },

    clear: function() {
      this._leaveChildren();
      this.$table.hide();
    }
  });

  var Account = Support.CompositeView.extend({
    tagName: 'tr',
    attributes: {
      'data-resource': 'user'
    },

    events: {
      'click button' : 'commit',
      'click input[type=checkbox]' : 'toggleButtonDisability'
    },

    render: function() {
      this.$el.html(
        templates.account({
          user: this.model,
          button: this.createButton(this.model)
        })
      );

      this.$button = this.$('button');
      this.$checkbox = this.$('input');
      return this;
    },

    createButton: function(user) {
      if ( !user.id ) {
        return templates.confirmationButton(user);
      } else {
        return 'Account Exists';
      }
    },

    toggleButtonDisability: function() {
      if ( this.$checkbox.is(':checked') ) {
        this.$button.removeAttr('disabled');
      } else {
        this.$button.attr('disabled', 'disabled');
      }
    },

    commit: function() {
      var view = this;

      if ( this.$checkbox.is(':checked') ) {
        return this.model.save({}, {
          success: function(account, response) {
            Besko.Support.notice('An email has been sent requesting approval of your account.');
            view.parent.clear();
          },
          error: function(account, response) {
            Besko.Support.error('there was a problem saving you\'re account');
          }
        });
      } else {
        this.$('.error').text('Confirmation must be checked.');
        return false;
      }
    }
  });

  Besko.Views.SignupForm = SignupForm;
})();
