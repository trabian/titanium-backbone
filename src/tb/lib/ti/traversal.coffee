# `slice` provides a mechanism for converting an extended array back into a
# regular Javascript array.
slice = [].slice

# These are from Zepto
classSelectorRE = /^\.([\w-]+)$/
idSelectorRE = /^#([\w-]*)$/

module.exports = ($) ->

  _matches = (element, selector) ->

    return false unless element

    if match = selector.match classSelectorRE
      element.class is match[1]
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

    node = @[0]

    while node and not _matches node, selector
      node = (node isnt context) and node.parent

    $(node)

  is: (selector) ->
    _matches @[0], selector
