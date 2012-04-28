(function() {
// With additions by Maciej Adwent http://github.com/Maciek416
// If token name and value are not supplied, this code Requires jQuery
//
// Adapted from:
// http://www.ngauthier.com/2011/02/backbone-and-rails-forgery-protection.html
// Nick Gauthier @ngauthier
  var AuthTokenAdapter = {
    // Create wrapper for Backbone.sync
    // Arguments:
    //   Backbone - the Backbone object
    //   paramName (optional) - authtoken param name
    //   paramValue (optional) - authtoken param value
    fixSync: function(Backbone, paramName, paramValue) {
      if ( typeof paramName === 'undefined' && typeof paramValue === 'undefined' ) {
        paranName = $('meta[name="csrf-param"]').attr('content');
        paramValue = $('meta[name="csrf-token"]').attr('content');
      }

      // Alias existing .sync
      Backbone._sync = Backbone.sync;

      Backbone.sync = function(method, model, options) {

        // If we're using a post/put method, add auth options on the model
        if ( method === 'create' || method === 'update' || method === 'delete' ) {
          authOptions = {};
          authOptions[paramName] = paramValue;

          model.set(authOptions, { silent: true });
        }

        Backbone._sync(method, model, options);
      }
    },

    // restore back sync
    restoreSync: function(Backbone) {
      Backbone.sync = Backbone._sync;
    }
  }

  AuthTokenAdapter.fixSync(Backbone);

  _.extend(Besko.Support = AuthTokenAdapter);
})();
