matchers = require './helpers/matchers'
mini = require './helpers/mini'
viewHandlers = require './helpers/view_handlers'

# `slice` provides a mechanism for converting an extended array back into a
# regular Javascript array.
slice = [].slice

module.exports =

  concat: [].concat

  each: (callback) ->

    _.each @, (el) ->
      callback.apply el, arguments

    @

  find: (selector) ->
    @map ->
      $ mini.find selector, @

  map: (fn) ->

    mapWithExtend = (el, i) ->
      fn.call el, i, el

    $ _.chain(@)
      .map(mapWithExtend)
      .flatten()
      .value()


  add: (el) ->
    $ @concat $ el

  get: (index) ->
    if index?
      @[index]
    else
      slice.call @

  children: ->
    @map ->
      viewHandlers.handle 'children', @

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
