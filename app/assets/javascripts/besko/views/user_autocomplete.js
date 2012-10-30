(function() {
  var templates = {
    root: _.template('\
      <label for="user-search"><%= label %></label>'),

    result: _.template('\
      <%- name() %>\
      <div class="result-details">\
        <%- details() %>\
      </div>')
  };

  var UserSearch = Support.CompositeView.extend({
    className: 'input search autocomplete-search',

    events: {
      'click [data-close]' : 'clear'
    },

    initialize: function(options) {
      options = options || {};
      this.collection = new Besko.Collections.Users;

      this.labelText = options.labelText || 'Search for a user';
      this.params = options.params || {};

      this.bindTo(this, 'select', this.clear);
      this.bindTo(this.collection, 'reset', this.renderResults);
    },

    render: function() {
      this.$el.html(templates.root({ label: this.labelText }));

      this.search = new Search;
      this.appendChild(this.search);

      this.$close = $('<span>').addClass('autocomplete-close').attr('data-close', true).text('Close');
      this.$el.append(this.$close);

      return this;
    },

    renderResults: function() {
      this.leaveResults();

      var results = this.collection.length ? ResultSet : EmptyResults;
      this.results = new results({ collection: this.collection });

      this.appendChild(this.results);

      this.$close.addClass('open');
    },

    fetch: function(search) {
      this.collection.fetch({
        data: {
          term: search,
          options: this.params
        }
      });
    },

    clear: function() {
      this.leaveResults();

      this.search.$el.val('').focus();
      this.$close.removeClass('open');
    },

    leaveResults: function() {
      if ( this.results ) {
        this.results.leave();
      }
    }
  });

  var Search = Support.CompositeView.extend({
    tagName: 'input',

    id: 'user-search',

    attributes: {
      name: 'user-search',
      type: 'search',
      placeholder: 'Enter name or email',
      autofocus: true
    },

    events: {
      'keyup' : 'search',
      'keydown' : 'checkForSelect'
    },

    render: function() {
      return this;
    },

    search: function(event) {
      var search = this.$el.val();

      if ( _.contains([38, 40], event.keyCode) ) {
        event.preventDefault();
      } else if ( search.length >= 3 ) {
        this.parent.fetch(search);
      } else if ( !search && this.parent.results ) {
        this.parent.clear();
      }
    },

    checkForSelect: function(event) {
      var method;

      if ( _.contains([13, 38, 40], event.keyCode) ) {
        event.preventDefault();

        switch ( event.keyCode ) {
          case 13:
            method = 'select';
            break;

          case 38:
            method = 'up';
            break;

          case 40:
            method = 'down';
            break;
        }

        if ( this.parent.results ) {
          this.parent.results[method](event);
        }
      }
    }
  });

  var ResultSet = Support.CompositeView.extend({
    tagName: 'ul',

    className: 'autocomplete-results',

    attributes: {
      'data-collection' : 'users',
    },

    events: {
      'click [data-resource=user]' : 'select'
    },

    render: function() {
      var subview, view = this;

      this.collection.each(function(model) {
        subview = new Result({ model: model });
        view.appendChild(subview);
      });

      this.$results = this.$el.children();

      return this;
    },

    select: function(event) {
      var index, model;

      if ( event.keyCode && this.$selected ) {
        index = this.$selected.index();
      } else if ( event.keyCode && !this.$selected ) {
        index = 0;
      } else {
        index = $(event.target).index();
      }

      model = this.collection.at(index);

      this.parent.trigger('select', model);
      this.parent.search.$el.val('').focus();

      this.leave();
    },

    up: function(event) {
      if ( !this.initSelected(event.keyCode) ) {
        this.navigate(-1);
      }
    },

    down: function(event) {
      if ( !this.initSelected(event.keyCode) ) {
        this.navigate(1);
      }
    },

    initSelected: function(code) {
      if ( this.$selected ) {
        return false;
      }

      var method = code === 38 ? 'last' : 'first';
      this.$selected = this.$results[method]().addClass('selected');
      return true;
    },

    navigate: function(direction) {
      var target = this.$selected.removeClass('selected').index() + direction;
      var methods = direction === 1 ? ['first', 'next'] : ['last', 'prev'];

      this.$selected.removeClass('selected');

      if ( target < 0 || target === this.$results.length ) {
        this.$selected = this.$results[methods[0]]().addClass('selected');
      } else {
        this.$selected = this.$selected[methods[1]]().addClass('selected');
      }
    }
  });

  var EmptyResults = Support.CompositeView.extend({
    className: 'empty-autocomplete-results autocomplete-results',

    render: function() {
      this.$el.text('No Results');
    },

    select: function() {},
    up: function() {},
    down: function() {}
  });

  var Result = Support.CompositeView.extend({
    tagName: 'li',

    className: 'autocomplete-result',

    attributes: {
      'data-resource' : 'user'
    },

    events: {
      'mouseover' : function(event) {
        this.$el.siblings().removeClass('selected');
        this.$el.addClass('selected');
        this.parent.$selected = this.$el;
      },
      'mouseout' : function(event) {
        this.$el.removeClass('selected')
        this.parent.$selected = null;;
      }
    },

    render: function() {
      this.$el.html(templates.result(this.model));

      return this;
    },
  });

  Besko.Views.UserAutocomplete = UserSearch;
})();
