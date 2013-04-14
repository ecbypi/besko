(function() {
  "use strict";

  Besko.DateField = Ember.TextField.extend({
    dateFormatBinding: 'controller.dateFormat',

    didInsertElement: function() {
      var self = this;

      this.$().datepicker({
        minDate: 'Tue, Oct 19, 2010',
        maxDate: new Date().strftime(this.get('dateFormat')),
        dateFormat: 'D, M dd, yy',
        changeMonth: true,
        changeYear: true,
        selectOtherMonths: true,
        showOtherMonths: true,
        onSelect: function(dateText, options) {
          self.get('controller').set('date', new Date(dateText));
        },
        buttonText: 'Change',
        showOn: 'button',
        autosize: true,
        hideIfNoPrevNext: true
      });
    }
  });
})();
