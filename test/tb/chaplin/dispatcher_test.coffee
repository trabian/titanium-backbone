helpers = require '../../helpers'

{ assert } = helpers.chai

Chaplin = helpers.require 'chaplin'
Dispatcher = helpers.require 'tb/chaplin/dispatcher'

describe 'Chaplin dispatcher', ->

  beforeEach ->

    @dispatcher = new Dispatcher

  afterEach ->
    @dispatcher.dispose()

  it 'should be available', ->
    assert.ok @dispatcher

  it 'should set a controllerPath and controllerSuffix', ->
    assert.ok @dispatcher.settings.controllerPath
    assert.ok @dispatcher.settings.controllerSuffix

  it 'should listen to the global matchRoute event and call startupController', (done) ->

    route =
      controller: 'sample'
      action: 'show'

    _params =
      id: 1

    _options =
      test: 'true'

    @dispatcher.startupController = (controllerName, action, params, options) ->
      assert.equal controllerName, route.controller
      assert.equal action, route.action
      assert.deepEqual params, _params
      assert.deepEqual options, _options
      done()

    Chaplin.mediator.publish 'matchRoute', route, _params, _options

  it 'should find and call the correct controller and action', (done) ->

    class SampleController extends Chaplin.Controller

      show: -> done()

    @dispatcher.loadController = (controllerName, handler) ->

      if controllerName is 'sample'
        handler SampleController

    Chaplin.mediator.publish 'matchRoute',
      controller: 'sample'
      action: 'show'

  it 'should not dispose the previous controller if they are using the same layout', (done) ->

    firstDisposed = false

    class FirstController extends Chaplin.Controller

      layout: 'stacked'

      index: ->

      dispose: ->
        firstDisposed = true
        super

    class SecondController extends Chaplin.Controller

      layout: 'stacked'

      index: ->
        assert.isFalse firstDisposed
        done()

    @dispatcher.loadController = (controllerName, handler) ->

      handler switch controllerName
        when 'first'
          FirstController
        when 'second'
          SecondController

    Chaplin.mediator.publish 'matchRoute',
      controller: 'first'

    Chaplin.mediator.publish 'matchRoute',
      controller: 'second'

  it 'should not dispose the previous controller if the new controller doesnt have a defined layout', (done) ->

    firstDisposed = false

    class FirstController extends Chaplin.Controller

      layout: 'stacked'

      index: ->

      dispose: ->
        firstDisposed = true
        super

    class SecondController extends Chaplin.Controller

      index: ->
        assert.isFalse firstDisposed
        done()

    @dispatcher.loadController = (controllerName, handler) ->

      handler switch controllerName
        when 'first'
          FirstController
        when 'second'
          SecondController

    Chaplin.mediator.publish 'matchRoute',
      controller: 'first'

    Chaplin.mediator.publish 'matchRoute',
      controller: 'second'

  it 'should dispose all controllers in the previous layout', (done) ->

    firstDisposed = false
    secondDisposed = false

    class FirstController extends Chaplin.Controller

      layout: 'some-layout'

      index: ->

      dispose: ->
        firstDisposed = true
        super

    class SecondController extends Chaplin.Controller

      layout: 'some-layout'

      index: ->

      dispose: ->
        secondDisposed = true
        super

    class ThirdController extends Chaplin.Controller

      layout: 'some-other-layout'

      index: ->
        assert.isTrue firstDisposed
        assert.isTrue secondDisposed
        done()

    @dispatcher.loadController = (controllerName, handler) ->

      handler switch controllerName
        when 'first'
          FirstController
        when 'second'
          SecondController
        when 'third'
          ThirdController

    Chaplin.mediator.publish 'matchRoute',
      controller: 'first'

    Chaplin.mediator.publish 'matchRoute',
      controller: 'second'

    Chaplin.mediator.publish 'matchRoute',
      controller: 'third'
