View = require 'tb/views/base'

module.exports = class Window extends View

  viewName: 'Window'

  attributes:
    backgroundColor: '#090'

window = new Window

window.el.open()
