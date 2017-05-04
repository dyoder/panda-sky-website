# UGLY HACK WARNING
# There are hooks, but there's no 'before' hook
# (there's a beforeHighlight hook, but that doesn't fire if the language
# file isn't found), and when I tried adding a complete hook,
# that ended up being even uglier.

do (f = undefined) ->
  f = Prism.highlightElement
  Prism.highlightElement = (element, async, callback) ->
    $element = $(element)
    $element.addClass "line-numbers"
    if $element.hasClass "lang-coffee"
      $element.removeClass "lang-coffee"
      $element.addClass "lang-coffeescript"
    f element, async, callback

Prism.plugins.autoloader.languages_path = '/prism/components/'
