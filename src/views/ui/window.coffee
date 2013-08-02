styles = require('styles/ui').window

environment = require 'environment'

mediator = require 'chaplin/mediator'

View = require 'views/base'

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

    super

    if @options.title
      @title = @options.title

    if @title
      @view.title = _.result @, 'title'

      if environment.android

        { ActionBarPresenter } = require 'core/presenters/action_bar'
        ActionBar = require 'views/android/action_bar'

        @barPresenter = new ActionBarPresenter
          title: @view.title
          actionsWidth: @actionsWidth

        @add bar = new ActionBar
          presenter: @barPresenter

        @actionBarHeight = bar.view.height

    if environment.android
      @view.navBarHidden = true

    # This introduces a dependence on the 'trabian-banking-core-mobile',
    # but we need to combine those anyway

    @delegateEvents
      open: => @resolve?() if @resolveOnOpen
      close: =>
        @closed = true
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

    wrapperStyle =
      height: Ti.UI.FILL

    if @actionBarHeight
      wrapperStyle.top = @actionBarHeight

    @wrap wrapperStyle, (view) =>

      layout = @make 'View', options.style or styles.layouts.default

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

    # @view.hide()

    @trigger 'close'

    if _.isFunction options
      callback = options
      options = {}

    if callback

      if environment.android

        _.defer ->
          callback()
          return

      else
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

  dispose: ->

    return if @disposed

    @view.close() unless @closed

    super

