/* global Support */
(function() {
  'use strict';

  var AutocompleteInput,
      AutocompleteResult,
      AutocompleteResults,
      AutocompleteResetButton;

  function defaultOnSelectCallback(searchView, model) {
    var input = searchView.input,
        resetButton = searchView.resetButton;

    input.$el.
      val(model.escape("value")).
      attr('disabled', '');

    resetButton.show();
  }

  function defaultOnResetCallback(searchView) {
    searchView.input.$el.
      val('').
      removeAttr('disabled');
  }

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
      'data-resource' : 'autocomplete_result'
    },

    template: _.template('\
      <%= escape("value") %>\
      <div class="result-details">\
        <%= escape("details") %>\
      </div>'),

    render: function() {
      var markup = this.template(this.model);
      this.$el.html(markup);

      return this;
    },

    focus: function() {
      this.parent.changeFocusedResult(this);
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

    currentFocusedResult: function() {
      return this.children.find(function(child) {
        return child.focused === true;
      }).value();
    },

    select: function(model) {
      // If called from pressing 'Enter' with no arguments, find the focused
      // result or default to the first one if none have been highlighted
      if ( !model ) {
        var focusedView = this.currentFocusedResult() || this.children.first().value();
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
          focused = this.currentFocusedResult(),
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
    },

    changeFocusedResult: function(targetResult) {
      var currentResult = this.currentFocusedResult();

      if ( currentResult ) {
        currentResult.blur();
      }

      targetResult.focused = true;
      targetResult.$el.addClass('focused');
    }
  });

  AutocompleteResetButton = Support.CompositeView.extend({
    events: {
      'click' : 'reset'
    },

    render: function() {
      var view = this;

      this.listenTo(this.collection, 'request', this.hide);
      this.listenTo(this.collection, 'reset', function(collection) {
        var value = this.parent.input.$el.val();

        if ( collection.isEmpty() ) {
          if ( !!value ) {
            view.show();
          } else {
            view.hide();
          }
        } else {
          view.show();
        }
      });
    },

    show: function() {
      this.$el.show();
    },

    hide: function() {
      this.$el.hide();
    },

    reset: function() {
      this.hide();
      this.trigger('reset');
    }
  });

  Besko.Views.AutocompleteSearch = Support.CompositeView.extend({
    events: {
      'keydown' : 'navigateResults'
    },

    initialize: function(options) {
      this.onSelect = options.onSelect || defaultOnSelectCallback;
      this.onReset = options.onReset || defaultOnResetCallback;
    },

    render: function() {
      var input, results, loading, resetButton;

      input = new AutocompleteInput({
        el: this.$('input'),
        collection: this.collection
      });
      this.renderChild(input);

      results = new AutocompleteResults({
        el: this.$('[data-collection]'),
        collection: this.collection
      });
      this.renderChild(results);

      loading = new Besko.Views.LoadingAnimation({
        el: this.$('[data-loading]'),
        collection: this.collection
      });
      this.renderChild(loading);

      resetButton = new AutocompleteResetButton({
        el: this.$('[data-clear-results]'),
        collection: this.collection
      });
      this.renderChild(resetButton);

      this.listenTo(results, 'select', this.select);
      this.listenTo(resetButton, 'clear', this.reset);

      this.input = input;
      this.results = results;
      this.loading = loading;
      this.resetButton = resetButton;

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
      this.collection.reset();
      this.onSelect(this, model);
      this.trigger('select', model);
    },

    reset: function() {
      this.collection.reset();
      this.onReset(this);
      this.trigger('reset');
    }
  });
})();
