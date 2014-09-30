//= require besko/collections/users

/* global Routes */
(function() {
  'use strict';

  Besko.Collections.DeskWorkers = Besko.Collections.Users.extend({
    url: Routes.users_path({ category: 'desk_worker' })
  });
})();
