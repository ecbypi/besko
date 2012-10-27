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
        <%- details() %>\
      </div>')
  };

  var UserSearch = Support.CompositeView.extend({
    className: 'input search',

    events: {
      'click [data-resource=user]' : 'select',
      'click [data-close]' : 'clear',
      'keyup #user-search' : 'fetch',
      'keydown #user-search' : 'navigateOrSelect'
    },

    initialize: function(options) {
      options = options || {};
      this.collection = new Besko.Collections.Users;

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

      return this;
    },

    renderResults: function() {
      var subview,
          view = this,
          $results = this.$results;

      this.$selected = undefined;

      if ( this.collection.length ) {
        this.collection.each(function(user) {
          subview = new Result({ model: user });
          view.appendChildTo(subview, $results);
        });

      } else if ( this.$search.val() ) {
        subview = new NullResult({ manualAdditions: this.options.manualAdditions });
        this.appendChildTo(subview, $results);
      }

      this.$wrapper.addClass('open');
    },

    fetch: function(event) {
      var search = this.$search.val();

      if ( _.contains([38, 40], event.keyCode) ) {
        event.preventDefault();
      } else if ( search.length >= 3) {
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

    navigateOrSelect: function(event) {
      if ( _.contains([38, 40, 13], event.keyCode) ) {
        event.preventDefault();
      }

      if ( _.contains([38, 40], event.keyCode) && !this.$selected ) {
        var method = event.keyCode === 38 ? 'last' : 'first';
        this.highlightFirst(method);
        return;
      }

      switch ( event.keyCode ) {
        case 13:
          this.selectHighlighted();
          break;

        case 38:
          this.highlightUp();
          break;

        case 40:
          this.highlightDown();
          break;
      }
    },

    highlightUp: function() {
      var index = this.$selected.removeClass('selected').index(),
          target = index -= 1;

      if ( target < 0 ) {
        this.highlightFirst('last');
      } else {
        this.$selected = this.$selected.prev().addClass('selected');
      }
    },

    highlightDown: function() {
      var index = this.$selected.removeClass('selected').index(),
          target = index += 1;

      if ( target === this.$results.children().length ) {
        this.highlightFirst('first');
      } else {
        this.$selected = this.$selected.next().addClass('selected');
      }
    },

    highlightFirst: function(method) {
      this.$selected = this.$results.children()[method]().addClass('selected');
    },

    select: function(event) {
      var index = $(event.target).index(),
          model = this.collection.at(index);

      this.trigger('select', model);
    },

    selectHighlighted: function() {
      var index, model;

      if ( this.$selected ) {
        index = this.$selected.index();
      }

      model = this.collection.at(index || 0);

      this.trigger('select', model);
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

    events: {
      'hover' : function(event) {
        this.$el.toggleClass('selected')
      }
    },

    render: function() {
      this.$el.html(templates.result(this.model));

      return this;
    },
  });

  var NullResult = Support.CompositeView.extend({
    tagName: 'li',

    className: 'autocomplete-result empty-autocomplete-result',

    render: function() {
      this.$el.html('<span>No Results</span>');
    }
  });

  Besko.Views.UserAutocomplete = UserSearch;
})();
