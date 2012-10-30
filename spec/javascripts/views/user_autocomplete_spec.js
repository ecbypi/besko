//= require application

describe("Besko.Views.UserAutocomplete", function() {
  var users, view, $users, $search, server,
    data = [
      { name: 'Micro Helpline', details: 'mrhalp@mit.edu | N42' },
      { name: 'Ms Helpline', details: 'mshalp@mit.edu | N42' }
    ];

  beforeEach(function() {
    view = new Besko.Views.UserAutocomplete;
    view.render();

    users = view.collection;

    $users = view.$('[data-collection=users]');
    $search = view.$('#user-search');

    server = sinon.fakeServer.create();

    $search.val('help').keyup();

    server.requests[0].respond(
      200,
      { "Content-Type" : "application/json" },
      JSON.stringify(data)
    );
  });

  afterEach(function() {
    server.restore();
  });

  it("allows customization of the search input label text", function() {
    var customView = new Besko.Views.UserAutocomplete({ labelText: 'Find a user!' }).render();

    expect(customView.$el).toHaveText(/Find a user!/);
  });

  it("renders a search input with a label", function() {
    expect(view.$el).toContain('input#user-search[type=search]');
    expect(view.$el).toContain('label[for=user-search]');
  });

  it("renders the users in list", function() {
    expect(view.$el).toContain('[data-resource=user]:contains("Micro Helpline")');
    expect(view.$el).toContain('[data-resource=user]:contains("Ms Helpline")');
  });

  it("makes suggestion selected on hover", function() {
    var $user = view.$('[data-resource=user]:first');

    $user.mouseover();

    expect($user).toBe('.selected');
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

    it("a 'keyup' is triggered and the results are empty", function() {
      $search.val('');
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

    it("removes the 'open' class from the close button", function() {
      var close = view.$('[data-close]');

      expect(close).toHaveClass('open');

      view.clear();

      expect(close).not.toHaveClass('open');
    });

    it("handles case where results are not present", function() {
      var unfetchedView = new Besko.Views.UserAutocomplete;
      unfetchedView.render();

      unfetchedView.clear();
    });
  });

  describe("'select' event is triggered when", function() {
    var listener, enter;

    beforeEach(function() {
      listener = sinon.spy();

      enter = jQuery.Event('keydown');
      enter.keyCode = 13;

      view.on('select', listener);
    });

    it("any user element is clicked", function() {
      view.$('[data-resource=user]:last').click();

      expect(listener).toHaveBeenCalledWith(users.at(1));
    });

    it("'enter' key is pressed, selecting the first user in the list", function() {
      $search.trigger(enter);

      expect(listener).toHaveBeenCalledWith(users.at(0));
    });

    it("'enter' key is pressed after navigating the list", function() {
      var down = jQuery.Event('keydown');
      down.keyCode = 40;

      // Move down twice so we're on the second suggestion
      $search.trigger(down);
      $search.trigger(down);
      $search.trigger(enter);

      expect(listener).toHaveBeenCalledWith(users.at(1));
    });
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

  describe("navigates list when", function() {
    var enter, user1, user2;

    beforeEach(function() {
      enter = jQuery.Event('keydown');
      user1 = view.$('[data-resource=user]:first');
      user2 = view.$('[data-resource=user]:last');
    });

    it("down key is pressed", function() {
      enter.keyCode = 40;

      $search.trigger(enter);

      expect(user1).toBe('.selected');
      expect(user2).not.toBe('.selected');

      $search.trigger(enter);

      expect(user1).not.toBe('.selected');
      expect(user2).toBe('.selected');
    });

    it("up key is pressed", function() {
      enter.keyCode = 38;

      $search.trigger(enter);

      expect(user1).not.toBe('.selected');
      expect(user2).toBe('.selected');

      $search.trigger(enter);

      expect(user1).toBe('.selected');
      expect(user2).not.toBe('.selected');
    });
  });

  it("renders 'no results' if nothing matches", function() {
    $search.keyup();

    server.requests[1].respond(
      200,
      { "Content-Type" : "application/json" },
      JSON.stringify([])
    );

    expect(view.$el).toHaveText(/No Results/);
  });
});
