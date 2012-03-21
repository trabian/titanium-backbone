styles = require('styles/ui').window

View = require 'views/base'

module.exports = class Window extends View

  viewName: 'Window'

  attributes: (extensions) ->
    if extensions
      _.extend {}, styles.view, extensions
    else
      styles.view

  events:
    close: 'destroy'

  layout: (options, callback) =>

    # If only one parameter is included in method call, treat it as the
    # callback.
    unless callback?
      callback = options
      options = {}

    @wrap (view) =>

      view.add layout = @make 'View', options.style or styles.layouts.default

      callback layout

  open: (options) => @view.open options

  close: (options) => @view.close options

  destroy: => @trigger 'destroy'

  _bindControllerEvents: =>
    @controller?.context ?= @
    super
