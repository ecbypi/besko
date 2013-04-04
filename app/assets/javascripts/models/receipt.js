(function() {
  "use strict";

  Besko.Receipt = DS.Model.extend({
    numberPackages: DS.attr('number'),
    comment: DS.attr('string'),
    signedOutAt: DS.attr('date'),
    user: DS.belongsTo('Besko.User')
  });
})();
