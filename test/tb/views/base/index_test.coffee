helpers = require '../../../helpers'

{ assert } = helpers.chai

describe 'BaseView', ->

  it 'should create a Titanium view when initialized', ->
    assert.ok (new Backbone.View).el

  # These should pass unchanged from the Backbone.View tests
  describe 'constructor', ->

    beforeEach ->

      @view = new Backbone.View
        id: 'test-view'
        className: 'test-view'
        other: 'non-special-option'

    it 'should initialize the view correctly', ->
      assert.equal @view.id, 'test-view'
      assert.equal @view.className, 'test-view'
      assert.ok ! @view.other
      assert.equal @view.options.id, 'test-view'
      assert.equal @view.options.className, 'test-view'
      assert.equal @view.options.other, 'non-special-option'

    it 'should support options as a function', ->

      class ExtendedView extends Backbone.View

        options: ->
          other: 'other-attribute'

      view = new ExtendedView

      assert.equal view.options.other, 'other-attribute'
      assert.ok ! view.other

    it 'should rename "tagName" to "viewName"', ->

      class ExtendedView extends Backbone.View

        viewName: 'Button'

      view = new ExtendedView

      assert.isTrue view.$el.is 'Button'

    describe "attributes", ->

      it "should allow attributes"

      it "should merge attributes passed in the constructor", ->

        class ExtendedView extends Backbone.View

          attributes:
            color: 'blue'
            height: 30

        view = new ExtendedView
          attributes:
            color: 'red'

        assert.equal view.attributes.color, 'red'
        assert.equal view.attributes.height, 30

  describe 'events', ->

    it 'should allow events to be specified as strings', ->

      class ExtendedView extends Backbone.View

        clicked: false

        events:
          click: 'clickMethod'

        clickMethod: ->
          @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

    it 'should allow events to be bubbled up from child views', ->

      class ExtendedView extends Backbone.View

        clicked: false

        events:
          'click #someChild': 'clickMethod'

        render: =>

          Backbone.$('<View>')
            .appendTo(@$el)
            .attr('id', 'someChild')

          @

        clickMethod: ->
          @clicked = true

      view = new ExtendedView

      $child = view.render().$el.children()

      assert.isFalse view.clicked

      $child.trigger 'click'

      assert.isTrue view.clicked, 'Click event was not fired'

    it 'should allow events to be specified as inline functions', ->

      class ExtendedView extends Backbone.View

        clicked: false

        events: ->

          click: =>
            @clicked = true

      view = new ExtendedView

      assert.isFalse view.clicked

      view.$el.trigger 'click'

      assert.isTrue view.clicked

    it 'should allow events to be specified as references to object methods', ->

      class ExtendedView extends Backbone.View

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

      class ExtendedView extends Backbone.View

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

  describe 'child views', ->

    describe 'adding a View object', ->

      it 'should save the view to the element\'s "children" array', ->

        class ViewWithChildren extends View

          render: ->

            @$el.append (new View).el

            @

        view = new ViewWithChildren

        view.render()

        assert.equal view.el.children.length, 1

    describe 'clearing child views', ->

      it 'should be able to empty the child views', ->

        class ViewWithChildren extends View

          render: ->

            @$el.append (new View).el

            @

        view = new ViewWithChildren

        view.render()

        view.$el.empty()

        assert.equal view.el.children.length, 0
