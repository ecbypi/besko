Besko.DateField = Ember.TextField.extend({
  dateFormatBinding: 'controller.dateFormat',

  didInsertElement: function() {
    var self = this;

    this.$().datepicker({
      minDate: 'Tuesday, October 19, 2010',
      maxDate: Besko.Date().strftime(this.get('dateFormat')),
      dateFormat: 'DD, MM dd, yy',
      changeMonth: true,
      changeYear: true,
      selectOtherMonths: true,
      showOtherMonths: true,
      onSelect: function(dateText, options) {
        self.get('controller').set('date', Besko.Date(dateText));
      },
      buttonText: 'Change',
      showOn: 'button',
      autosize: true,
      hideIfNoPrevNext: true
    });
  }
});
