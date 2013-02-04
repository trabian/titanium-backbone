Chaplin = require 'chaplin'

Dispatcher = require './dispatcher'
LayoutManager = require './views/layout_manager'

History = require './lib/history'

module.exports = class Application extends Chaplin.Application

  initialize: ->

    Backbone.history = new History

    Chaplin.Route::getCurrentQueryString = ->
      Backbone.history.path.split(/\?/)[1]

    super

  initLayoutManager: (options) ->
    @layoutManager = new LayoutManager options

  initDispatcher: (options) ->
    @dispatcher = new Dispatcher options
