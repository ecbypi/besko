/* global Routes */
(function() {
  'use strict';

  Besko.Collections.Recipients = Backbone.Collection.extend({
    url: Routes.recipients_path()
  });
})();
