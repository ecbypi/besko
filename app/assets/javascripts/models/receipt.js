Besko.Receipt = DS.Model.extend({
  numberPackages: DS.attr('number'),
  comment: DS.attr('string'),
  signedOutAt: DS.attr('date'),
  recipient: DS.belongsTo('Besko.User')
});
