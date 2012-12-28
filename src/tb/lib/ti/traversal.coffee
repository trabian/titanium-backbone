module.exports = ($) ->

  each: (callback) ->

    _.each @, (el) ->
      callback.apply el, arguments

  children: ->

    _.chain(@)
      .pluck('children')
      .flatten()
      .value()

  parent: -> $ @[0].parent
