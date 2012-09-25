(function() {
  var UserSearch = Backbone.View.extend({
    tagName: 'input',
    id: 'user-search',
    attributes: {
      type: 'search',
      placeholder: 'Enter name, email or kerberos',
      autofocus: true
    },

    events: {
      'keydown' : function(event) {
        if ( event.keyCode === 13 ) {
          event.preventDefault();
        }
      }
    },

    // May be a bit unorthodox to have a view render itself into the parent in
    // the initialize method, but this removes some biolerplate so for now I'm
    // okay with it.
    initialize: function(options) {
      var searchOptions = {},
          view = this,
          selector = options.selector || '.search',
          context = options.context;

      if ( options.local ) {
        searchOptions.local_only = true;
      }

      if ( options.remote ) {
        searchOptions.remote_only = true;
      }

      this.params = $.param({
        options: searchOptions
      });

      this.$el.autocomplete({
        source: '/users.json?' + this.params,
        select: function(event, ui) {
          view.options.select(context, event, ui);

          $(this).val('');
          return false;
        }
      });

      context.$(selector).append(this.el);
    },

    render: function() {
      return this;
    }
  });

  Besko.Views.UserSearch = UserSearch;
})();
