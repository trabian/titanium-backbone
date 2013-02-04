styles = require('styles/ui').window

{ ActionBarPresenter } = require 'core/presenters/action_bar'

environment = require 'environment'

mediator = require 'chaplin/mediator'

if environment.android
  ActionBar = require 'views/android/action_bar'

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

        @barPresenter = new ActionBarPresenter
          title: @view.title

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
