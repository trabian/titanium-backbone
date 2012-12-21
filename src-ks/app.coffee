module.exports =

  run: ->
    @createWindow 'basic_with_event'

  createWindow: (name) ->

    Window = require "views/windows/#{name}"

    window = new Window

    window.el.open()
