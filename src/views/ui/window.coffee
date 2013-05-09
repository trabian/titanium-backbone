styles = require('styles/ui').window

mediator = require 'chaplin/mediator'

View = require 'views/base'

environment = require 'environment'

module.exports = class Window extends View

  viewName: 'Window'

  autoResolve: false

  resolveOnOpen: true

  publishActivityOnClick: true

  attributes: (extensions) ->
    if extensions
      _.extend {}, styles.view, extensions
    else
      styles.view

  initialize: ->

    if @options.title
      @view.title = @options.title
    else if @title
      @view.title = _.result @, 'title'

    if @options.resolveOnOpen?
      @resolveOnOpen = @options.resolveOnOpen

    super

    # This introduces a dependence on the 'trabian-banking-core-mobile',
    # but we need to combine those anyway

    @delegateEvents
      open: => @resolve?() if @resolveOnOpen
      close: =>
        mediator.publish 'activity'
        @destroy?()

    if @publishActivityOnClick
      @delegateEvents
        click: -> mediator.publish 'activity'

  layout: (options, callback) =>

    # If only one parameter is included in method call, treat it as the
    # callback.
    unless callback?
      callback = options
      options = {}

    @wrap { height: Ti.UI.FILL }, (view) =>

      layoutStyle = options.style or styles.layouts.default

      if environment.ipad
        layoutStyle.bottom = 50

      layout = @make 'View', layoutStyle

      if options.scroll

        scroll = @make 'ScrollView',
          height: Ti.UI.FILL
          contentHeight: 'auto'
          scrollType: 'vertical'

        scroll.add layout

        @on 'resize', -> scroll.setContentHeight 'auto'

        view.add scroll

      else

        view.add layout

      callback layout

  open: (options, callback) =>

    if _.isFunction options
      callback = options
      options = {}

    if callback
      @view.addEventListener 'open', ->
        callback()
        return

    @view.open options

  close: (options = {}, callback) =>

    return if @disposed

    @trigger 'close'

    if _.isFunction options
      callback = options
      options = {}

    if callback
      @view.addEventListener 'close', ->
        callback()
        return

    @view?.close options

  destroy: ->
    @trigger 'destroy'
    super
    @dispose?()

  _bindControllerEvents: =>
    @controller?.context ?= @
    super
