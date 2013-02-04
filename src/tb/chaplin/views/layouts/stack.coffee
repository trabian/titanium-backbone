View = require 'tb/views/base'

module.exports = class StackLayout extends View

  tagName: 'Window'

  showView: (view) ->

    if @$navGroup
      @$navGroup[0].open view.el

    else

      @$navGroup = $('<iPhone:NavigationGroup>')
        .attr('window', view.el)
        .appendTo @$el

      @el.open()

      @open = true

  dispose: ->
    return if @disposed
    console.warn 'disposed layout'
    super
