helpers = require '../../helpers'

{ assert } = helpers.chai

Chaplin = helpers.require 'chaplin'
Route = helpers.require 'chaplin/lib/route'
History = helpers.require 'tb/chaplin/lib/history'

describe 'History', ->

  beforeEach ->
    @history = new History()

  it 'should have handlers', ->
    assert.ok @history.handlers

  it 'should load the URL at root on start if a matching handler has been defined', (done) ->

    route =
      test: (path) -> path is ''
      handler: -> done()

    @history.handlers.push
      route: route
      callback: route.handler

    @history.start()

  it 'should support navigation', (done) ->

    root =
      test: (path) -> path is ''
      handler: ->

    issues =
      test: (path) -> /\/issues/.test path
      handler: -> done()

    @history.handlers.push
      route: root
      callback: root.handler

    @history.handlers.push
      route: issues
      callback: issues.handler

    @history.start()

    @history.navigate '/issues'

  it 'should pass params to the route', (done) ->

    root =
      test: (path) -> path is ''
      handler: ->

    issues = new Route '/issues/:id', 'issues', 'show'

    issues.getCurrentQueryString = ->

    issues.handler = (path, options) ->
      assert.equal options.test, 'this'
      done()

    @history.handlers.push
      route: root
      callback: root.handler

    @history.handlers.push
      route: issues
      callback: issues.handler

    @history.start()

    @history.navigate '/issues/3',
      test: 'this'

