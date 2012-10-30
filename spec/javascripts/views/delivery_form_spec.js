//= require application

describe("Besko.Views.DeliveryForm", function() {
  // Setup and testing
  var container, listener;

  // Top level components
  var view, $el, $form;

  // Inputs
  var $select;

  beforeEach(function() {
    loadFixtures('new_delivery');

    container = document.getElementById('content');
    view = new Besko.Views.DeliveryForm({ el: container });
    view.render();

    $el = view.$el;
    $form = view.$('form');
    $select = view.$('.inputs select');
  });

  afterEach(function() {
    view.remove();
  });

  it("renders the autocomplete input for users", function() {
    expect($el).toContain('.input.autocomplete-search');
  });

  describe("validations", function() {
    beforeEach(function() {
      listener = sinon.spy(Besko.Support, 'error');
    });

    afterEach(function() {
      Besko.Support.error.restore();
    });

    it("prevents submission if no deliverer is selected", function() {
      $form.trigger('ajax:before');

      expect(listener).toHaveBeenCalledWith('A deliverer is required to log a delivery.');
    });

    it("prevents submission if no recipients have been added", function() {
      $select.val('One');
      $form.trigger('ajax:before');

      expect(listener).toHaveBeenCalledWith('At least on recipient is required for a delivery.');
    });
  });

  describe("resetting", function() {
    beforeEach(function() {
      view.$('[data-cancel]').click();
    });

    it("hides the table of recipients", function() {
      expect(view.$('tfoot, thead')).toBeHidden();
    });

    it("resets deliverer input", function() {
      expect($select.val()).toEqual('');
    });
  });
});
