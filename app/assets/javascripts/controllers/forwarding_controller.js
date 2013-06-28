(function() {
  'use strict';

  Besko.ForwardingController = Ember.ArrayController.extend(Besko.AutocompleteMixin, {
    search: function(query) {
      this.set('autocompleteResults', Besko.ForwardingAddress.find({ q: query }));
    },

    tableVisible: function() {
      return this.get('content.length') > 0 && !this.get('printing');
    }.property('content.length', 'printing'),

    add: function(address) {
      var count = address.get('labelCount'),
          content = this.get('content'),
          index = this.get('content').indexOf(address);

      if ( index === -1 ) {
        content.pushObject(address);
      } else {
        count = parseInt(count, 10) + 1;
        address.set('labelCount', count);
      }
    },

    remove: function(address) {
      if ( confirm('Remove ' + address.get('name') + '?') ) {
        this.get('content').removeObject(address);
      }
    },

    togglePrinting: function() {
      this.toggleProperty('printing');
    },

    clear: function() {
      this.get('content').clear();
    }
  });
})();
