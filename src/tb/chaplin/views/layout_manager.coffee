EventBroker = require 'chaplin/lib/event_broker'
utils = require 'chaplin/lib/utils'

module.exports = class LayoutManager

  # Borrow the static extend method from Backbone
  @extend = Backbone.Model.extend

  # Mixin an EventBroker
  _(@prototype).extend EventBroker

  constructor: ->
    @layouts = {}
    @views = []
    @initialize arguments...

  initialize: (options = {}) ->

    @settings = _(options).defaults
      layoutPath: 'layouts/'
      layoutSuffix: ''

    @subscribeEvent 'startupController', @showNewView

  showNewView: (context) ->

    if @layout = @loadLayout context.layout
      view = context.controller?.view

      @layout.showView view

      @views.push view

      view.delegateNewEvents
        close: =>
          @views = _.without @views, view
          view.dispose()

  loadLayout: (name) ->

    name ?= @settings.default

    if layout = @layouts[name]
      layout

    else

      fileName = utils.underscorize(name) +
        @settings.layoutSuffix

      moduleName = @settings.layoutPath + fileName

      layoutModule = require moduleName
      @layouts[name] = new layoutModule

  disposed: false

  dispose: ->

    return if @disposed

    for name, layout of @layouts
      layout.dispose()

    view.dispose() for view in @views

    @unsubscribeAllEvents()

    delete @layout

    @disposed = true

    # You’re frozen when your heart’s not open
    Object.freeze? this
