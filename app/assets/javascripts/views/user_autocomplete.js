Besko.UserAutocomplete = Ember.View.extend({
  classNames: ['input', 'search', 'autocomplete-search'],
  templateName: 'autocomplete',

  results: function() {
    return this.get('childViews').findProperty('tagName', 'ul');
  }.property(),

  search: function() {
    return this.get('childViews').findProperty('tagName', 'input');
  }.property(),

  keyDown: function(event) {
    var method;

    if ( [13, 38, 40].contains(event.keyCode) ) {
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
    elementId: 'user-search',
    timerBinding: 'parentView.timer',

    attributeBindings: ['name', 'type', 'placeholder', 'autofocus'],
    name: 'user-search',
    type: 'search',
    placeholder: 'Enter a name or email',
    autofocus: true,

    keyUp: function(event) {
      var code = event.keyCode,
          value = this.get('value'),
          controller = this.get('context');

      if ( code === 38 || code === 40 ) {
        event.preventDefault();
      } else if ( value.length >= 3 && ( ( code <= 90 && code >= 46 ) || [8, 32, 110, 189].contains(code) ) ) {
        controller.search(value);
      } else if ( !value ) {
        controller.set('users', []);
      }

      return false;
    }
  }),

  resultSet: Ember.CollectionView.extend({
    contentBinding: 'controller.users',

    tagName: 'ul',
    classNames: ['autocomplete-results'],

    attributeBindings: ['data-collection'],
    'data-collection': 'users',

    selected: function() {
      return this.get('childViews').findProperty('selected', true);
    }.property('childViews.@each.selected'),

    selectedIndex: function() {
      return this.get('childViews').indexOf(this.get('selected'));
    }.property('selected'),

    select: function(event) {
      var selected = this.get('selected') || this.get('childViews').objectAt(0),
          recipient = selected.get('content'),
          controller = this.get('context');

      if ( !recipient.get('id') ) {
        var transaction = this.get('context.store').transaction();

        // Create a Recipient model to use a different API endpoint since the
        // behavior for creating a user and creating a recipient when logging a
        // package differ. Additionally, ember-data doesn't let me re-save a
        // record if it is clea, which all the user records are when returned
        // from the server, even though they don't have an ID.
        recipient = transaction.createRecord(
          Besko.Recipient,
          recipient.getProperties('firstName', 'lastName', 'email', 'login', 'street')
        )

        recipient.on('didCreate', function() {
          controller.add(recipient);
        });

        transaction.commit();
      } else {
        controller.add(recipient);
      }

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
      var selected = this.get('selected'),
          children = this.get('childViews'),
          endPosition = direction === 1 ? 'firstObject' : 'lastObject';

      if ( !selected ) {
        selected = children.get(endPosition);
        selected.set('selected', true);
        return;
      }

      var target, targetIndex = this.get('selectedIndex') + direction;

      if ( targetIndex < 0 || targetIndex === children.get('length') ) {
        target = children.get(endPosition);
      } else {
        target = children.objectAt(targetIndex);
      }

      selected.set('selected', false)
      target.set('selected', true)
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

      attributeBindings: ['data-resource'],
      'data-resource': 'user',

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
