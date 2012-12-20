module.exports =

  run: ->
    @createWindow()

  createWindow: ->

    BasicWindow = require 'views/windows/basic'

    basicWindow = new BasicWindow

    basicWindow.el.open()
