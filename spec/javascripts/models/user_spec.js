//= require application

describe("Besko.Models.User", function() {
  var user;

  it("has a method for the full name", function() {
    user = new Besko.Models.User({first_name: 'Micro', last_name: 'Helpline'});
    expect(user.name()).toEqual('Micro Helpline');
  });
});
