//= require_self

//= require notifications
//= require parsing

//= require ./besko/router
//= require_tree ./besko/views

(function() {
  "use strict";

  window.Besko = {
    Views: {}
  };

  $(function() {
    new Besko.Router();
    Backbone.history.start({ pushState: true, hashChange: false });
  });
})();
