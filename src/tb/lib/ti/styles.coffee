styler = require 'tb/lib/styler'

module.exports = ($) ->

  style: ->

    for selector, attributes of styler.styles
      @find(selector).attr attributes

    @
