//= require application

describe("Besko.Views.DeliveryForm", function() {
  var form, recipient, search, callback;

  beforeEach(function() {
    form = new Besko.Views.DeliveryForm({
      model: new Besko.Models.Delivery({})
    });

    recipient = {
      id: 1,
      first_name: 'Micro',
      last_name: 'Helpline',
      login: 'mrhalp',
      email: 'mrhalpmit.edu'
    };

    form.render();

    search = form.$('#user-search');
    callback = search.autocomplete('option', 'select');
  });

  it("has the class 'new-delivery'", function() {
    expect(form.$el).toBe('.new-delivery');
  });

  describe("it(contains a(n)", function() {

    it("empty table of receipts", function() {
      expect(form.$el).toContain('table[data-collection=receipts]');
    });

    it("search field to lookup recipients", function() {
      expect(form.$el).toContain('input[type=search]');
    });

    it("select field for delivery company", function() {
      expect(form.$el).toContain('select[name=deliverer]');
    });

    it("button to send all notifications", function() {
      expect(form.$el).toContain('button[data-role=commit]');
    });

    it("button to cancel all receipts", function() {
      expect(form.$el).toContain('button[data-role=cancel]');
    });
  });


  describe("supports specifying 'Other' deliverer", function() {
    it("by switching out the select with a text field", function() {
      form.$('select').val('Other');
      form.$('select').trigger('change');
      expect(form.$el).toContain('input#deliverer[type=text]');
      expect(form.$('input#deliverer')).toHaveAttr('autofocus');
    });
  });

  describe("adds receipts to the table when selecting a recipient", function() {
    beforeEach(function() {
      callback.apply(search, [{}, {item: recipient}]);
    });

    afterEach(function() {
      form.reset();
    });

    it("as a table row", function() {
      var $tbody = form.$el.find('tbody');

      expect($tbody).toContain('tr[data-resource=receipt]');
      expect($tbody.children().length).toEqual(1);

      var $receipt = $tbody.find('tr');
      expect($receipt).toContain('input[name=number_packages][value=1]');
      expect($receipt).toContain('textarea[name=comment]');
      expect($receipt).toHaveText(/Micro Helpline/);
    });

    it("and errors out if someone is added twice", function() {
      sinon.spy(Besko.Support, 'error');
      callback.apply(search, [{}, {item: recipient}]);

      expect(Besko.Support.error).toHaveBeenCalled();
      Besko.Support.error.restore();
    });
  });

  describe("removes receipts", function() {
    beforeEach(function() {
      callback.apply(search, [{}, {item: recipient}]);
    });

    it("by clicking 'Remove' button in table row", function() {
      expect(form.$('tbody')).not.toBeEmpty();
      form.$('tbody tr button[data-cancel]').click();
      expect(form.$('tbody')).toBeEmpty();
    });

    it("but allows them to be added back again", function() {
      sinon.spy(Besko.Support, 'error');

      form.$('tbody tr button[data-cancel]').click();
      callback.apply(search, [{}, {item: recipient}]);

      expect(Besko.Support.error).not.toHaveBeenCalled();

      Besko.Support.error.restore();
    });
  });

  describe("#commit()", function() {
    describe("when in an invalid state", function() {
      it("returns false", function() {
        var output = form.commit();
        expect(output).toEqual(false);
      });
    });
  });

});
