helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ event methods', ->

  beforeEach ->
    @el = ti.createView 'View'
    @$el = $ @el

  it 'should have a "bind" method', ->
    assert.ok @$el.bind

  it 'should have an "on" method', ->
    assert.ok @$el.on

  it 'should have an "off" method', ->
    assert.ok @$el.off

  it 'should have an "unbind" method', ->
    assert.ok @$el.unbind

  it 'should have a "trigger" helper', ->

    assert.ok @$el.trigger

    triggerCalled = false

    @el.fireEvent = ->
      triggerCalled = true

    @$el.trigger 'someEvent'

    assert.ok triggerCalled

  it 'should have a "triggerHandler" helper', ->

    assert.ok @$el.triggerHandler

    triggerCalled = false

    @$el.bind 'someEvent', =>
      triggerCalled = true

    @$el.triggerHandler 'someEvent'

    assert.ok triggerCalled

  it 'should bind and unbind events to views', ->

    clicked = false

    clickHandler = (e) ->
      clicked = e.someData is 'some data'

    click = =>
      @el.fireEvent 'click',
        someData: 'some data'

    @$el.bind 'click', clickHandler

    click()

    assert.isTrue clicked, 'Event was not bound'

    clicked = false

    @$el.unbind 'click', clickHandler

    click()

    assert.isFalse clicked, 'Event was not unbound'

  it 'should treat "on" and "off" the same as "bind" and "unbind"', ->

    clicked = false

    clickHandler = (e) ->
      clicked = e.someData is 'some data'

    click = =>
      @el.fireEvent 'click',
        someData: 'some data'

    @$el.on 'click', clickHandler

    click()

    assert.isTrue clicked, 'Event was not bound'

    clicked = false

    @$el.off 'click', clickHandler

    click()

    assert.isFalse clicked, 'Event was not unbound'

  it 'should pass the arguments to "trigger" as e.data', ->

    clickHandler = (e) ->
      assert.equal e.data, 'some data'

    @$el.on 'click', clickHandler

    @$el.trigger 'click', 'some data'

  describe 'unbinding', ->

    beforeEach ->

      @clickHandler = =>
        @clicked = true

      @$el.bind 'click.currentNamespace', @clickHandler

      @fire = =>
        @clicked = false
        @el.fireEvent 'click'

      @fire()

    it 'should not unbind event handlers in a different namespace', ->

      assert.isTrue @clicked, 'Event was not bound'

      @$el.unbind 'click.otherNamespace', @clickHandler

      @fire()

      assert.isTrue @clicked

    it 'should unbind event handlers in the same namespace', ->

      @$el.unbind 'click.currentNamespace', @clickHandler

      @fire()

      assert.isFalse @clicked

    it 'should unbind event handlers if the namespace is empty', ->

      @$el.unbind 'click', @clickHandler

      @fire()

      assert.isFalse @clicked

    it 'should not unbind event handlers with a different event name', ->

      @$el.unbind 'otherEventName', @clickHandler

      @fire()

      assert.isTrue @clicked

    it 'should not unbind event handlers with a different handler', ->

      @$el.unbind 'click', =>

      @fire()

      assert.isTrue @clicked

    it 'should unbind event handlers with an empty handler', ->

      @$el.unbind 'click'

      @fire()

      assert.isFalse @clicked
