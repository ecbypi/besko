//= require application

describe("Besko.Views.DeliverySearch", function() {
  var view;

  beforeEach(function() {
    view = new Besko.Views.DeliverySearch({
      collection: new Besko.Collections.Deliveries([
        {
          worker: {
            id: 1,
            email: 'mrhalpmit.edu',
            first_name: 'Micro',
            last_name: 'Helpline'
          },
          package_count: 2,
          delivered_at: '10:30:10 AM',
          deliverer: 'UPS',
          receipts: []
        }
      ]),
      date: '2010-10-30'
    });
    view.render();
  });

  it("has buttons for next and previous day", function() {
    expect(view.$el).toContain('button.next');
    expect(view.$el).toContain('button.prev');
  });

  it("has an <h2> tag for showing what day we're on", function() {
    expect(view.$el).toContain('h2');
  });

  it("has an input for the jquery datepicker", function() {
    expect(view.$('h2')).toContain('input.hasDatePicker');
    expect(view.$('h2').find('input.hasDatePicker').val()).toMatch(/Saturday, October 30, 2010/);
  });

  it("tracks the current date", function() {
    expect(view.date.getUTCFullYear()).toEqual(2010);
    expect(view.date.getUTCMonth()).toEqual(9);
    expect(view.date.getUTCDate()).toEqual(30);
  });

  it("lists deliveries in the table", function() {
    expect(view.$el).toContain('table[data-collection=deliveries]');

    var $tr = view.$('tr[data-resource=delivery]');

    expect($tr).toContain('td:contains("2")');
    expect($tr).toContain('td:contains("UPS")');
    expect($tr).toContain('td:contains("10:30:10 AM")');
    expect($tr).toContain('a[href="mailto:mrhalpmit.edu"]:contains("Micro Helpline")');
  });
});
