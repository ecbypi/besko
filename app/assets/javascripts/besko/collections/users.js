/* global Routes */
(function() {
  'use strict';

  Besko.Collections.Users = Backbone.Collection.extend({
    url: Routes.users_path()
  });
})();
