Besko.Delivery = DS.Model.extend({
  deliverer: DS.attr('string'),
  deliveredOn: DS.attr('date'),
  worker: DS.belongsTo('Besko.User'),
  receipts: DS.hasMany('Besko.Receipt'),
  receiptsAttributes: DS.attr('nestedAttributesArray')
});
