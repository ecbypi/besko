(function() {
  var templates = {
    root: _.template('\
      <label for="user-search"><%= label %></label>\
      <input type="search" name="search" autofocus id="user-search" placeholder="Enter name or email"/>\
      <div class="autocomplete-results-wrapper">\
        <a href="javascript:void(0)" class="autocomplete-close" data-close>Close</a>\
        <ul data-collection="users"></ul>\
      </div>'),

    result: _.template('\
      <%= escape("name") %>\
      <div class="result-details">\
        <%= escape("details") %>\
      </div>')
  };

  var UserSearch = Support.CompositeView.extend({
    className: 'input search',

    events: {
      'click [data-resource=user]' : 'selectClicked',
      'click [data-close]' : 'clear',
      'keyup #user-search' : 'fetch',
      'keydown #user-search' : 'selectFirst'
    },

    initialize: function(options) {
      options = options || {};
      this.collection = this.collection || new Besko.Collections.Users;

      this.labelText = options.labelText || 'Search for a user';
      this.params = options.params || {};

      this.bindTo(this, 'select', this.clear);
      this.bindTo(this.collection, 'reset', this._leaveChildren);
      this.bindTo(this.collection, 'reset', this.renderResults);
    },

    render: function() {
      this.$el.html(templates.root({ label: this.labelText }));

      this.$search = this.$('#user-search');
      this.$results = this.$('[data-collection=users]');
      this.$wrapper = this.$results.parent();

      this.renderResults();
      return this;
    },

    renderResults: function() {
      var subview,
          view = this,
          $results = this.$results;

      if ( this.collection.length ) {
        this.collection.each(function(user) {
          subview = new Result({ model: user });
          view.appendChildTo(subview, $results);
        });

        this.$wrapper.addClass('open');
      }
    },

    fetch: function(event) {
      var search = this.$search.val();

      if ( search.length >= 3) {
        this.collection.fetch({
          data: {
            term: search,
            options: this.params
          }
        });
      } else if ( !search ) {
        this.clear();
      }
    },

    selectClicked: function(event) {
      var index = $(event.target).index(),
          model = this.collection.at(index);

      this.trigger('select', model);
    },

    selectFirst: function(event) {
      if ( event.keyCode === 13 ) {
        event.preventDefault();
        this.trigger('select', this.collection.at(0));
      }
    },

    clear: function(event) {
      this.$wrapper.removeClass('open');
      this._leaveChildren();
      this.$search.val('').focus();
    }
  });

  var Result = Support.CompositeView.extend({
    tagName: 'li',

    className: 'autocomplete-result',

    attributes: {
      'data-resource' : 'user'
    },

    render: function() {
      this.$el.html(templates.result(this.model));

      return this;
    },
  });

  Besko.Views.UserAutocomplete = UserSearch;
})();
