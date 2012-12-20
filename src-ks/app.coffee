module.exports =

  run: ->
    @createWindow()

  createWindow: ->

    View = require 'tb/views/base'

    class Window extends View

      viewName: 'Window'

      attributes:
        backgroundColor: '#DB0E00'

      events: ->
        open: ->

          @$el.trigger 'other',
            message: 'some message'

        other: (e) ->

          alert e.message

    window = new Window

    window.el.open()
