Besko.Delivery = DS.Model.extend({
  deliverer: DS.attr('string'),
  deliveredOn: DS.attr('date'),
  deliveredAt: DS.attr('string'),
  packageCount: DS.attr('number'),
  user: DS.belongsTo('Besko.User'),
  receipts: DS.hasMany('Besko.Receipt'),
  receiptsAttributes: DS.attr('nestedAttributesArray'),

  becameError: function() {
    Besko.error('There was a problem saving the delivery. Try again.');
  },

  becameInvalid: function(delivery) {
    var error = delivery.get('errors.firstObject');
    Besko.error('There was a problem saving the delivery because ' + error);
  }
});
