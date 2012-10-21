//= require application

describe("Besko.Views.UserAutocomplete", function() {
  var view, $users, $search,
    users = new Besko.Collections.Users([
      { name: 'Micro Helpline', details: 'mrhalp@mit.edu | N42' },
      { name: 'Ms Helpline', details: 'mshalp@mit.edu | N42' }
    ]);

  beforeEach(function() {
    view = new Besko.Views.UserAutocomplete({ collection: users });

    view.render();

    $users = view.$('[data-collection=users]');
    $wrapper = $users.parent();
    $search = view.$('#user-search');
  });

  it("allows customization of the search input label text", function() {
    var customView = new Besko.Views.UserAutocomplete({ labelText: 'Find a user!' }).render();

    expect(customView.$el).toHaveText(/Find a user!/);
  });

  it("renders a search input with a label", function() {
    expect(view.$el).toContain('input#user-search[type=search]');
    expect(view.$el).toContain('label[for=user-search]');
  });

  describe("toggling visibility", function() {
    var emptyView, $emptyWrapper

    beforeEach(function() {
      emptyView = new Besko.Views.UserAutocomplete({});
      emptyView.render();

      $emptyWrapper = emptyView.$('.autocomplete-results-wrapper');
    });

    afterEach(function() {
      emptyView.leave();
    });

    it("adds 'open' class if there are any results", function() {
      expect($emptyWrapper).not.toHaveClass('open');

      expect($wrapper).toHaveClass('open');
    });
  });

  it("renders the users in list", function() {
    expect(view.$el).toContain('[data-resource=user]:contains("Micro Helpline")');
    expect(view.$el).toContain('[data-resource=user]:contains("Ms Helpline")');
  });

  describe("resets the users list when", function() {
    it("clicking the close link", function() {
      view.$('[data-close]').click();

      expect($users).not.toContain('[data-resource=user]');
    });

    it("selecting a user", function() {
      view.$('[data-resource=user]:first').click();

      expect($users).not.toContain('[data-resource=user]');
    });

    it("a 'keyup' is triggered and the results are search is empty", function() {
      $search.keyup();

      expect($users).not.toContain('[data-resource=user]');
    });
  });

  describe("#clear", function() {
    it("empties the search input", function() {
      $search.val('search');
      view.clear();

      expect($search.val()).toEqual('');
    });

    it("removes the 'open' class from the list of users", function() {
      view.clear();

      expect($users).not.toHaveClass('open');
    });
  });

  it("triggers 'select' event when picking a user passing the user model to the callback", function() {
    var listener = sinon.spy();
    view.on('select', listener);

    view.$('[data-resource=user]:first').click();

    expect(listener).toHaveBeenCalledWith(users.models[0]);
  });

  describe("fetches users on input's keyup", function() {
    beforeEach(function() {
      sinon.spy(users, 'fetch');
    });

    afterEach(function() {
      users.fetch.restore();
    });

    it("if the value is 3 characters or greater", function() {
      $search.val('micro').keyup();

      expect(users.fetch).toHaveBeenCalled();
    });

    it("if the value is less than 3 characters", function() {
      $search.val('ms').keyup();

      expect(users.fetch).not.toHaveBeenCalled();
    });
  });
});
