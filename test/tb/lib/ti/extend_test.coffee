helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe 'extend', ->

  beforeEach ->
    @el = ti.createView 'View'
    @$el = $ @el

  it 'should return an extended element', ->
    assert.ok @$el

  it 'should provide array-based access to a collection', ->
    assert.equal @el, @$el[0]

  describe 'events', ->

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

      clickHandler = (someData) ->
        clicked = someData is 'some data'

      @$el.bind 'click', clickHandler

      @el.fireEvent 'click', 'some data'

      assert.isTrue clicked, 'Event was not bound'

      clicked = false

      @$el.unbind 'click', clickHandler

      @el.fireEvent 'click', 'some data'

      assert.isFalse clicked, 'Event was not unbound'

    it 'should treat "on" and "off" the same as "bind" and "unbind"', ->

      clicked = false

      clickHandler = (someData) ->
        clicked = someData is 'some data'

      @$el.on 'click', clickHandler

      @el.fireEvent 'click', 'some data'

      assert.isTrue clicked, 'Event was not bound'

      clicked = false

      @$el.off 'click', clickHandler

      @el.fireEvent 'click', 'some data'

      assert.isFalse clicked, 'Event was not unbound'

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

  describe 'manipulation', ->

    it 'should be able to append a child view', ->

      @$el.append ti.createView 'View'
      @$el.append ti.createView 'View'

      assert.equal @$el.children().length, 2

    it 'a view appended to an existing view should have a reference to its parent', ->

      @$el.append newEl = ti.createView 'View'

      $newEl = $(newEl)

      assert.equal $newEl.parent()[0], @$el[0]

    it 'should be able to remove child views', ->

      @$el.append newView = ti.createView 'View'
      @$el.append otherView = ti.createView 'View'

      $(newView).remove()

      assert.equal @$el.children().length, 1

      assert.equal @$el.children()[0], otherView

    it 'should be able to empty all views', ->

      @$el.append ti.createView 'View'
      @$el.append ti.createView 'View'

      @$el.empty()

      assert.equal @$el.children().length, 0

    it 'should be able to hide the views', ->

      @$el.hide()
      assert.isTrue @$el[0].hidden

    it 'should be able to show the hidden views', ->

      @$el.hide()
      assert.isTrue @$el[0].hidden

      @$el.show()
      assert.isFalse @$el[0].hidden

    it 'should be able to chain manipulation methods', ->

      @$el
        .append(ti.createView 'View')
        .hide()

      assert.equal @$el.children().length, 1
      assert.isTrue @$el[0].hidden

      @$el
        .empty()
        .show()

      assert.equal @$el.children().length, 0
      assert.isFalse @$el[0].hidden
  it 'should allow creation of a new view by passing a string', ->
    assert.equal $('<View>')[0].toString(), '[object TiUIView]'
    assert.equal $('<View/>')[0].toString(), '[object TiUIView]'
    assert.equal $('<View />')[0].toString(), '[object TiUIView]'

    assert.ok $('<iPhone::NavigationGroup>')[0]
