(function() {
  'use strict';

  Besko.Models.User = Backbone.Model.extend({
    urlRoot: Routes.users_path(),

    initialize: function(attributes) {
      var value, details;

      value = attributes.first_name + ' ' + attributes.last_name;

      details = attributes.email;
      if ( !!attributes.street ) {
        details += '| ' + attributes.street;
      }

      this.attributes.value = value;
      this.attributes.details = details;
    }
  });
})();
