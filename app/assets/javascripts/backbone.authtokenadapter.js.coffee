# With additions by Maciej Adwent http://github.com/Maciek416
# If token name and value are not supplied, this code Requires jQuery
#
# Adapted from:
# http://www.ngauthier.com/2011/02/backbone-and-rails-forgery-protection.html
# Nick Gauthier @ngauthier
@BackboneRailsAuthTokenAdapter =
  # Create wrapper for Backbone.sync
  # Arguments:
  #   Backbone - the Backbone object
  #   paramName (optional) - authtoken param name
  #   paramValue (optional) - authtoken param value
  fixSync: (Backbone, paramName, paramValue) ->
    unless paramName? and paramValue?
      paranName = $('meta[name="csrf-param"]').attr('content')
      paramValue = $('meta[name="csrf-token"]').attr('content')

    # Alias existing .sync
    Backbone._sync = Backbone.sync

    Backbone.sync = (method, model, options) ->

      # If we're using a post/put method, add auth options on the model
      if method is 'create' or method is 'update' or method is 'delete'
        authOptions = {}
        authOptions[paramName] = paramValue

        model.set authOptions, silent: true

      Backbone._sync method, model, options

  # restore back sync
  restoreSync: (Backbone) ->
    Backbone.sync = Backbone._sync

@BackboneRailsAuthTokenAdapter.fixSync Backbone
