helpers = require '../../helpers'

{ assert } = helpers.chai

Chaplin = helpers.require 'chaplin'
Dispatcher = helpers.require 'tb/chaplin/dispatcher'
LayoutManager = helpers.require 'tb/chaplin/views/layout_manager'
Layout = helpers.require 'tb/chaplin/views/layouts/base'
BaseView = helpers.require 'tb/views/base'

describe 'Layout manager', ->

  beforeEach ->
    @layoutManager = new LayoutManager

  afterEach ->
    unless @layoutManager.disposed
      @layoutManager.dispose()

  it 'should load the layout', (done) ->

    @layoutManager.loadLayout = (name, handler) ->
      assert.equal name, 'some-layout'
      done()

    Chaplin.mediator.publish 'startupController',
      layout: 'some-layout'

  it 'should tell the layout to show the view', (done) ->

    class View extends BaseView

    view = new View

    layout = new Layout

    layout.showView = (newView) ->
      assert.equal view, newView
      done()

    @layoutManager.loadLayout = (name) ->

      layout if name is 'some-layout'

    Chaplin.mediator.publish 'startupController',
      layout: 'some-layout'
      controller: { view }

  it 'should dispose of the view when closed', (done) ->

    class View extends BaseView

      tagName: 'Window'

    view = new View

    view.dispose = ->
      done()

    layout = new Layout

    @layoutManager.loadLayout = (name) ->
      layout if name is 'some-layout'

    Chaplin.mediator.publish 'startupController',
      layout: 'some-layout'
      controller: { view }

    view.el.close()

  it 'should dispose of all open views when disposed', (done) ->

    firstDisposed = false
    secondDisposed = false

    class View extends BaseView

      tagName: 'Window'

    firstView = new View
    secondView = new View

    firstView.dispose = ->
      firstDisposed = true

    secondView.dispose = ->
      secondDisposed = true

    layout = new Layout

    @layoutManager.loadLayout = (name) ->
      layout

    originalDispose = @layoutManager.dispose

    @layoutManager.dispose = =>
      originalDispose.call @layoutManager
      assert.isTrue firstDisposed
      assert.isTrue secondDisposed
      done()

    Chaplin.mediator.publish 'startupController',
      layout: 'some-layout'
      controller:
        view: firstView

    Chaplin.mediator.publish 'startupController',
      layout: 'some-layout'
      controller:
        view: secondView

    @layoutManager.dispose()

  it 'should dispose of all layouts when disposed', (done) ->

    firstDisposed = false
    secondDisposed = false

    class View extends BaseView

      tagName: 'Window'

    firstView = new View
    secondView = new View

    firstLayout = new Layout
    secondLayout = new Layout

    firstLayout.dispose = ->
      firstDisposed = true

    secondLayout.dispose = ->
      secondDisposed = true

    @layoutManager.loadLayout = (name) =>

      layout = switch name
        when 'first'
          firstLayout
        when 'second'
          secondLayout

      @layoutManager.layouts[name] ?= layout

      layout

    originalDispose = @layoutManager.dispose

    @layoutManager.dispose = =>
      originalDispose.call @layoutManager
      assert.isTrue firstDisposed
      assert.isTrue secondDisposed
      done()

    Chaplin.mediator.publish 'startupController',
      layout: 'first'
      controller:
        view: firstView

    Chaplin.mediator.publish 'startupController',
      layout: 'second'
      controller:
        view: secondView

    @layoutManager.dispose()
