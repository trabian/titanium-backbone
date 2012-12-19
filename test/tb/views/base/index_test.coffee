helpers = require '../../../helpers'

{ assert } = helpers.chai

View = helpers.require 'tb/views/base'

describe 'BaseView', ->

  it 'should create a Titanium view when initialized', ->
    assert.ok (new View).el

  # These should pass unchanged from the Backbone.View tests
  describe 'constructor', ->

    beforeEach ->

      @view = new View
        id: 'test-view'
        className: 'test-view'
        other: 'non-special-option'
        presenter: 'some-presenter'

    it 'should initialize the view correctly', ->
      assert.equal @view.id, 'test-view'
      assert.equal @view.className, 'test-view'
      assert.ok ! @view.other
      assert.equal @view.options.id, 'test-view'
      assert.equal @view.options.className, 'test-view'
      assert.equal @view.options.other, 'non-special-option'

    it 'should allow a "presenter" as a "viewOption"', ->
      assert.equal @view.presenter, 'some-presenter'

    it 'should support options as a function', ->

      class ExtendedView extends View

        options: ->
          presenter: 'some-presenter'
          other: 'other-attribute'

      view = new ExtendedView

      assert.equal view.options.other, 'other-attribute'
      assert.ok ! view.other
      assert.equal view.presenter, 'some-presenter'

  describe 'make', ->

    beforeEach ->
      @view = new View

    it 'should pass attributes on to the view', ->

      el = @view.make 'View',
        testAttribute: 'test-attribute'

      assert.equal el.testAttribute, 'test-attribute'

    it 'should allow attributes to be passed in multiple hashes', ->

      firstAttributesHash =
        testAttribute: 'test-attribute'
        overriddenAttribute: 'should-be-overwritten'

      secondAttributesHash =
        otherAttribute: 'other-attribute'
        overriddenAttribute: 'overwrote'

      el = @view.make 'View', firstAttributesHash, secondAttributesHash

      assert.equal el.testAttribute, 'test-attribute'
      assert.equal el.otherAttribute, 'other-attribute'
      assert.equal el.overriddenAttribute, 'overwrote'

  describe 'events', ->

    it 'should allow events to be specified as strings', ->

      class ExtendedView extends View

        clicked: false

        events:
          click: 'clickMethod'

        clickMethod: ->
          @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

    it 'should allow events to be specified as inline functions', ->

      class ExtendedView extends View

        clicked: false

        events: ->

          click: =>
            @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

    it 'should allow events to be specified as references to object methods', ->

      class ExtendedView extends View

        clicked: false

        events: ->
          click: @click

        click: =>
          @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

    it 'should allow undelegation of events', ->

      class ExtendedView extends View

        clicked: false

        events:
          click: 'clickMethod'

        clickMethod: ->
          @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

      view.clicked = false

      view.undelegateEvents()

      view.$el.trigger 'click'

      assert.isFalse view.clicked

