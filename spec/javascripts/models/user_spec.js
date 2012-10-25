//= require application

describe("Besko.Models.User", function() {
  var user;

  it("has a method for the full name", function() {
    user = new Besko.Models.User({first_name: 'Micro', last_name: 'Helpline'});
    expect(user.name()).toEqual('Micro Helpline');
  });

  describe("#details", function() {
    it("joins street and email", function() {
      user = new Besko.Models.User({ street: '77 Mass Ave', email: 'mrhalp@mit.edu' });

      expect(user.details()).toEqual('mrhalp@mit.edu | 77 Mass Ave');
    });

    it("removes missing attributes", function() {
      user = new Besko.Models.User({ email: 'mrhalp@mit.edu', street: null });

      expect(user.details()).toEqual('mrhalp@mit.edu');
    });
  });
});
