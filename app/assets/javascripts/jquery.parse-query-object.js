//= require jquery.parsequery

(function() {
  "use strict";

  $.parseQuery.array_keys = /\[\]$/;

  $.parseQueryObject = function (options) {
    var params = $.parseQuery(options);

    $.each($.parseQuery(options), function (key, value) {
      var obj = params,
          parts = key.replace(/\]/g, '').replace(/\[$/, '').split('['),
          last = parts.pop();

      delete params[key];

      $.each(parts, function (i, part) {
        obj = obj[part] = obj[part] ? obj[part] : {};
      });

      obj[last] = value;
    });

    return params;
  };
})();
