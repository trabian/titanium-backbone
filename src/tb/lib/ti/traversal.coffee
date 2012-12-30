# `slice` provides a mechanism for converting an extended array back into a
# regular Javascript array.
slice = [].slice

module.exports = ($) ->

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
