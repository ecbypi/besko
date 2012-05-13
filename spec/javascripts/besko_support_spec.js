//= require application

describe("Besko.Support", function() {
  var model, parent, save;

  describe("notification methods", function() {
    it("manage messages", function() {
      loadFixtures('notifications');

      Besko.Support.error('Warning!');
      expect($('#notifications')).toContain('.error');
      expect($('#notifications')).toHaveText(/Warning!/);

      Besko.Support.notice('Hey there!');
      expect($('#notifications')).toContain('.notice');
      expect($('#notifications')).toHaveText(/Hey there!/);

      $link = $('#notifications').children('a.close-message');
      $link.click();
      expect($('#notifications')).toBeHidden();

      Besko.Support.notice('Hey there!');
      expect($('#notifications')).toBeVisible();
    });
  });

  describe(".bootstrap(ctor)", function() {
    it("takes bootstrapped data and passes it(into a constructor", function() {
      loadFixtures('bootstrap');
      model = Besko.Support.bootstrap(Backbone.Model);
      expect(model.constructor).toEqual(Backbone.Model);
    });
  });

  describe(".loadUser(model, name)", function() {
    it("takes a model and association name for the user and laods it(from data passed in", function() {
      model = new Backbone.Model({parent: {id: 1}});

      Besko.Support.loadUser(model, 'parent');

      expect(model.parent instanceof Besko.Models.User).toBeTruthy();
      expect(model.get('parent_id')).toEqual(1);
    });

    it("saves user information if unpersisted", function() {
      parent = new Besko.Models.User({});
      save = sinon.spy(parent, 'save');

      model = new Backbone.Model({parent: parent});

      Besko.Support.loadUser(model, 'parent');
      expect(save).toHaveBeenCalled();
    });
  });
});

