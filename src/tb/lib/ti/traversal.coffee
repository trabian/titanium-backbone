matchers = require './helpers/matchers'

# `slice` provides a mechanism for converting an extended array back into a
# regular Javascript array.
slice = [].slice

module.exports = ($) ->

  _matches = (element, selector) ->

    return false unless element

    if match = selector.match classSelectorRE
      element._class is match[1]
    else if match = selector.match idSelectorRE
      element.id is match[1]
    else
      element._viewName is selector

  each: (callback) ->

    _.each @, (el) ->
      callback.apply el, arguments

    @

  map: (fn) ->

    mapWithExtend = (el, i) ->
      fn.call el, i, el

    $ _.chain(@)
      .map(mapWithExtend)
      .flatten()
      .value()

  get: (index) ->
    if index?
      @[index]
    else
      slice.call @

  children: ->
    @map ->
      $(@children)

  parent: -> $ @[0].parent

  closest: (selector) ->

    parsed = matchers.parseSelector selector

    node = @[0]

    while node and not matchers.isParsedSelector node, parsed
      node = node.parent

    $(node)

  # Should be true if at least one of these elements matches the given
  # arguments.
  is: (selector) ->

    parsed = matchers.parseSelector selector

    _.some @, (el) ->
      matchers.isParsedSelector el, parsed
