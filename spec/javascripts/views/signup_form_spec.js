//= require application

describe("Besko.Views.SignupForm", function() {
  var view;

  beforeEach(function() {
    view = new Besko.Views.SignupForm({
      collection: new Besko.Collections.Users([
        {
          id: 1,
          first_name: 'Micro',
          last_name: 'Helpline',
          name: 'Micro Helpline',
          email: 'mrhalpmit.edu',
          login: 'mrhalp',
          street: 'N42'
        },
        {
          first_name: 'Micro',
          last_name: 'Helpline',
          name: 'Micro Helpline',
          email: 'mrhalpmit.edu',
          login: 'mrhalp',
          street: 'N42'
        }
      ])
    });
    view.render();
  });

  it("has a search input", function() {
    expect(view.$el).toContain('input[type=search]');
    expect(view.$el).toContain('button[data-role=search]');
  });

  it("has an empty table for search results", function() {
    expect(view.$el).toContain('table[data-collection=users]');
  });
});
