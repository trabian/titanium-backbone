styles = require('styles/ui').window

View = require 'views/base'

module.exports = class Window extends View

  viewName: 'Window'

  attributes: styles.view

  events:
    close: 'destroy'

  layout: (options, callback) =>

    # If only one parameter is included in method call, treat it as the
    # callback.
    unless callback?
      callback = options
      options = {}

    @view.add wrapper = @make 'View', options.style or styles.layouts.default

    callback wrapper

  open: => @view.open()

  close: => @view.close()

  destroy: => @trigger 'destroy'
