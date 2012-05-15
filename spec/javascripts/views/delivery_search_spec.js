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
          receipts: [
            {
              recipient_id: 2,
              number_packages: 3,
              comment: 'Heavy!',
              recipient: new Besko.Models.User({first_name: 'Ms', last_name: 'Helpline'})
            }
          ]
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

  it("lists deliveries in the table bodies", function() {
    expect(view.$el).toContain('table[data-collection=deliveries]');

    var $tr = view.$('tbody[data-resource=delivery]');

    expect($tr).toContain('td:contains("2")');
    expect($tr).toContain('td:contains("UPS")');
    expect($tr).toContain('td:contains("10:30:10 AM")');
    expect($tr).toContain('a[href="mailto:mrhalpmit.edu"]:contains("Micro Helpline")');
  });

  it("lists minimal receipt details per delivery as hidden rows", function() {
    expect(view.$el).toContain('tr[data-resource=receipt]');

    var $tr = view.$('tr[data-resource=receipt]');

    expect($tr).toContain('td:contains("Ms Helpline")');
    expect($tr).toContain('td:contains("3")');
    expect($tr).toContain('td:contains("Heavy!")');
  });

  it("allows toggling of receipt information by clicking on delivery table row only", function() {
    var $delivery = view.$('tbody[data-resource=delivery]'),
        $receipt = view.$('tr[data-resource=receipt]'),
        $deliveryRow = $delivery.children('tr:first-child');

    // This will be hidden via CSS, but I currently don't feel like loading CSS in
    // JS tests so this will do. Also helps ensure tests don't break if I break CSS.
    $receipt.hide();
    expect($receipt).toBeHidden();

    // jquery-jasmine doesn't seem to be seeing this as visible since it's not in the
    // DOM of the window object, hence we just check that the style attribute has been
    // emptied
    $deliveryRow.click()
    expect($receipt).toHaveAttr('style', '');

    // Make sure the email anchor tags work as intended
    $delivery.find('a').click()
    expect($receipt).toHaveAttr('style', '');

    // Only clicking the delivery table row will close things
    $deliveryRow.click();
    expect($receipt).toBeHidden();
  });
});
