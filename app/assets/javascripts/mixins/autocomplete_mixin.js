(function() {
  'use strict';

  Besko.AutocompleteMixin = Ember.Mixin.create({
    autocompleteResults: [],

    autocompleteSearching: function() {
      return this.get('autocompleteResults.isLoaded') === false;
    }.property('autocompleteResults.isLoaded')
  });
})();
