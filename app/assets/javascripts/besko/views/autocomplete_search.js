/* global Support */
(function() {
  'use strict';

  var AutocompleteInput,
      AutocompleteResult,
      AutocompleteResults;

  AutocompleteInput = Support.CompositeView.extend({
    events: {
      'keyup' : 'search'
    },

    search: function(event) {
      var code = event.keyCode,
          value = this.$el.val();

      if ( code === 18 || code === 40 ) {
        return false;
      } else if ( value.length >= 3 && value !== this.previousValue ) {
        var view = this;

        if ( this.searchTimer ) {
          clearTimeout(this.searchTimer);

          if ( this.xhr ) {
            this.xhr.abort();
            this.collection.reset();
          }
        }

        this.searchTimer = setTimeout(function() {
          view.xhr = view.collection.fetch({
            data: { term: value },
            reset: true
          });
        }, 400);
      } else if ( !value || value.length < 3 ) {
        clearTimeout(this.searchTimer);
        this.collection.reset();
      }

      this.previousValue = value;

      return false;
    },

    isEmpty: function() {
      return !this.$el.val();
    },

    reset: function() {
      this.$el.val('').focus();
    }
  });

  AutocompleteResult = Support.CompositeView.extend({
    events: {
      'mouseover' : 'focus',
      'mouseout' : 'blur',
      'click' : 'select'
    },

    tagName: 'li',

    className: 'autocomplete-result',

    attributes: {
      'data-resource' : 'user'
    },

    template: _.template('\
      <%= escape("first_name") %> <%= escape("last_name") %>\
      <div class="result-details">\
        <%= escape("email") %>\
        <% if ( !!get("street") ) { %>\
          | <%= escape("street") %>\
        <% } %>\
      </div>'),

    render: function() {
      var markup = this.template(this.model);
      this.$el.html(markup);

      return this;
    },

    focus: function() {
      var current = this.parent.currentlyFocusedResult();

      if ( current ) {
        current.blur();
      }

      this.focused = true;
      this.$el.addClass('focused');
    },

    blur: function() {
      this.focused = false;
      this.$el.removeClass('focused');
    },

    select: function() {
      this.trigger('select', this.model);
    }
  });

  AutocompleteResults = Support.CompositeView.extend({
    initialize: function() {
      this.listenTo(this.collection, 'request', this._leaveChildren());
      this.listenTo(this.collection, 'reset', this.render);
    },

    render: function() {
      var view = this, result;

      this._leaveChildren();
      this.collection.each(function(recipient) {
        result = new AutocompleteResult({ model: recipient });

        view.listenTo(result, 'select', view.select);
        view.appendChild(result);
      });

      return this;
    },

    currentlyFocusedResult: function() {
      return this.children.find(function(child) {
        return child.focused === true;
      }).value();
    },

    select: function(model) {
      // If called from pressing 'Enter' with no arguments, find the focused
      // result or default to the first one if none have been highlighted
      if ( !model ) {
        var focusedView = this.currentlyFocusedResult() || this.children.first().value();
        model = focusedView.model;
      }

      this.trigger('select', model);
    },

    up: function() {
      this.navigate(-1);
    },

    down: function() {
      this.navigate(1);
    },

    navigate: function(direction) {
      var target, targetIndex,
          focused = this.currentlyFocusedResult(),
          children = this.children.value(),
          endPosition = direction === 1 ? _.first : _.last;

      if ( !focused ) {
        focused = endPosition(children);
        focused.focus();
        return;
      }

      targetIndex = _.indexOf(children, focused) + direction;

      if ( targetIndex < 0 || targetIndex === children.length ) {
        target = endPosition(children);
      } else {
        target = children[targetIndex];
      }

      target.focus();
    }
  });

  Besko.Views.AutocompleteSearch = Support.CompositeView.extend({
    events: {
      'keydown' : 'navigateResults',
      'click [data-clear-results]' : 'reset'
    },

    initialize: function() {
      var $clearSearch = this.$('[data-clear-results]');

      this.listenTo(this.collection, 'request', function() {
        $clearSearch.hide();
      });
      this.listenTo(this.collection, 'reset', function(collection) {
        if ( collection.isEmpty() ) {
          $clearSearch.hide();
        } else {
          $clearSearch.show();
        }
      });
    },

    render: function() {
      this.input = new AutocompleteInput({
        el: this.$('input'),
        collection: this.collection
      });

      this.results = new AutocompleteResults({
        el: this.$('[data-collection]'),
        collection: this.collection
      });
      this.listenTo(this.results, 'select', this.select);

      this.loading = new Besko.Views.LoadingAnimation({
        el: this.$('[data-loading]'),
        collection: this.collection
      });
      this.loading.render();

      return this;
    },

    navigateResults: function(event) {
      var method,
          code = event.keyCode;

      if ( !this.collection.isEmpty() && _.contains([13, 38, 40], code) ) {
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

        this.results[method]();

        return false;
      } else if ( !this.input.isEmpty() && code === 13 ) {
        return false;
      }
    },

    select: function(model) {
      this.trigger('select', model);
    },

    reset: function() {
      this.collection.reset();
      this.input.reset();
    }
  });
})();
