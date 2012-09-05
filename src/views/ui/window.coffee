styles = require('styles/ui').window

View = require 'views/base'

module.exports = class Window extends View

  viewName: 'Window'

  attributes: (extensions) ->
    if extensions
      _.extend {}, styles.view, extensions
    else
      styles.view

  initialize: ->

    if @title
      @view.title = _.result @, 'title'

    super

  events:
    close: 'destroy'

  layout: (options, callback) =>

    # If only one parameter is included in method call, treat it as the
    # callback.
    unless callback?
      callback = options
      options = {}

    @wrap { height: Ti.UI.FILL }, (view) =>

      layout = @make 'View', options.style or styles.layouts.default

      if options.scroll

        scroll = @make 'ScrollView',
          height: Ti.UI.FILL
          contentHeight: 'auto'
          scrollType: 'vertical'

        scroll.add layout

        view.add scroll

      else

        view.add layout

      callback layout

  open: (options) => @view.open options

  close: (options, callback) =>

    if _.isFunction options
      callback = options
      options = {}

    if callback
      @view.addEventListener 'close', ->
        callback()
        return

    @view.close options

  destroy: ->
    @dispose?()

  _bindControllerEvents: =>
    @controller?.context ?= @
    super
