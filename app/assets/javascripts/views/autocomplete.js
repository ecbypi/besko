(function() {
  "use strict";

  Besko.Autocomplete = Ember.View.extend({
    classNames: ['input', 'search', 'autocomplete-search'],
    templateName: 'autocomplete',

    labelText: 'Search for a user',

    results: function() {
      return this.get('childViews').findProperty('tagName', 'ul');
    }.property(),

    search: function() {
      return this.get('childViews').findProperty('tagName', 'input');
    }.property(),

    keyDown: function(event) {
      var method,
          content = this.get('results.content');

      if ( !Ember.isEmpty(content) && [13, 38, 40].contains(event.keyCode) ) {
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

        this.get('results')[method](event);
      }
    },

    searchField: Ember.TextField.extend({
      elementId: 'autocomplete-search',

      attributeBindings: ['name', 'type', 'placeholder', 'autofocus'],
      name: 'autocomplete-search',
      type: 'search',
      placeholder: 'Enter a name or email',
      autofocus: true,

      timer: null,

      keyUp: function(event) {
        var code = event.keyCode,
            value = this.get('value'),
            previous = this.get('previousValue'),
            controller = this.get('controller');

        if ( code === 38 || code === 40 ) {
          event.preventDefault();
        } else if ( value.length >= 3 && value !== previous ) {
          this.setupDelayedSearch(value);
        } else if ( !value ) {
          Ember.run.cancel(this.get('timer'));
          controller.set('autocompleteResults', []);
        }

        this.set('previousValue', value);

        return false;
      },

      setupDelayedSearch: function(value) {
        var timer = this.get('timer'),
            controller = this.get('controller');

        if ( timer ) {
          Ember.run.cancel(timer);
        }

        if ( controller.get('autocompleteSearching') ) {
          controller.set('autocompleteResults', []);
        }

        this.set('timer', Ember.run.later(controller, 'search', value, 400));
      }
    }),

    closeSearch: Ember.View.extend({
      tagName: 'a',
      classNames: ['autocomplete-close', 'close'],
      classNameBindings: ['open'],

      open: function() {
        var value = this.get('parentView.search.value'),
            fetching = this.get('controller.autocompleteSearching'),
            results = this.get('controller.autocompleteResults');

        return value.length > 0 && !fetching || results.get('length') > 0;
      }.property('parentView.search.value', 'controller.autocompleteSearching'),

      click: function() {
        var search = this.get('parentView.search');

        search.set('value', '');
        this.get('controller').set('autocompleteResults', []);
        search.$().focus();

        return false;
      }
    }),

    resultSet: Ember.CollectionView.extend({
      contentBinding: 'controller.autocompleteResults',

      tagName: 'ul',
      classNames: ['autocomplete-results'],

      selected: function() {
        return this.get('childViews').findProperty('selected', true);
      }.property('childViews.@each.selected'),

      selectedIndex: function() {
        return this.get('childViews').indexOf(this.get('selected'));
      }.property('selected'),

      select: function(event) {
        var selected = this.get('selected') || this.get('childViews').objectAt(0),
            resource = selected.get('content'),
            controller = this.get('controller');

        controller.add(resource);

        this.get('parentView.search').set('value', '');
        this.set('content', []);
      },

      up: function(event) {
        this.navigate(-1);
      },

      down: function(event) {
        this.navigate(1);
      },

      navigate: function(direction) {
        var target, targetIndex,
            selected = this.get('selected'),
            children = this.get('childViews'),
            endPosition = direction === 1 ? 'firstObject' : 'lastObject';

        if ( !selected ) {
          selected = children.get(endPosition);
          selected.set('selected', true);
          return;
        }

        targetIndex = this.get('selectedIndex') + direction;

        if ( targetIndex < 0 || targetIndex === children.get('length') ) {
          target = children.get(endPosition);
        } else {
          target = children.objectAt(targetIndex);
        }

        selected.set('selected', false);
        target.set('selected', true);
      },

      itemViewClass: Ember.View.extend({
        tagName: 'li',
        classNames: ['autocomplete-result'],
        classNameBindings: ['selected'],
        template: Ember.Handlebars.compile('\
          {{view.content.name}}\
          <div class="result-details">\
            {{ view.content.details }}\
          </div>'),

        mouseEnter: function(event) {
          var current = this.get('parentView.selected');

          if ( current ) {
            current.set('selected', false);
          }

          this.set('selected', true);
        },

        mouseLeave: function(event) {
          this.set('selected', false);
        },

        click: function(event) {
          this.get('parentView').select(event);

          return false;
        }
      })
    })
  });
})();
