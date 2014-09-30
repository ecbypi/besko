//= require besko/collections/users

/* global Routes */
(function() {
  'use strict';

  Besko.Collections.Recipients = Besko.Collections.Users.extend({
    url: Routes.users_path({ category: 'recipient' })
  });
})();
