(function() {
  (function(f) {
    f = Prism.highlightElement;
    return Prism.highlightElement = function(element, async, callback) {
      var $element;
      $element = $(element);
      $element.addClass("line-numbers");
      if ($element.hasClass("lang-coffee")) {
        $element.removeClass("lang-coffee");
        $element.addClass("lang-coffeescript");
      }
      return f(element, async, callback);
    };
  })(void 0);

  Prism.plugins.autoloader.languages_path = '/prism/components/';

}).call(this);
