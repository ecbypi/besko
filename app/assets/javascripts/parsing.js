(function() {
  var parse = function(selector) {
    selector = selector || 'script#bootstrap';

    var unparsed = $(selector).text(),
        tmp = document.createElement('div');

    tmp.innerHTML = unparsed;
    return JSON.parse(tmp.innerHTML);
  };

  Besko.parseEmbeddedJSON = function(selector) {
    return parse(selector);
  };
})();
