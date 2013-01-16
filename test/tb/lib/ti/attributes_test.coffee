helpers = require '../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ attribute methods', ->

  beforeEach ->

    @el1 = ti.createView 'View'
    @el2 = ti.createView 'View'

    @$coll = $ [@el1, @el2]

  describe 'attr', ->

    it 'should be able to set an attribute on a collection of views', ->

      @$coll.attr 'left', 10

      assert.equal @el1.left, 10
      assert.equal @el2.left, 10

    it 'should be able to access an attribute on the first element of a view collection', ->

      @el1.left = 10

      assert.equal @$coll.attr('left'), 10

    it 'should be able to set multiple attributes on a view', ->

      @$coll.attr
        left: 10
        right: 20

      assert.equal @el1.left, 10
      assert.equal @el1.right, 20

      assert.equal @el2.left, 10
      assert.equal @el2.right, 20

    it 'should map the "class" attribute to _class', ->

      $(@el1).attr
        class: 'someClass'

      $(@el2).attr 'class', 'someOtherClass'

      assert.equal @el1._class, 'someClass'
      assert.equal @el2._class, 'someOtherClass'
      assert.equal $(@el1).attr('class'), 'someClass'

  describe 'removing attributes', ->

    beforeEach ->

      @$el = $(@el1)

      @$el.attr
        someAttr: 'someValue'

    it 'should allow removal of an attribute by setting an empty value in attr', ->

      @$el.attr 'someAttr', null

      assert.isFalse _.has @el1, 'someAttr'

    it 'should allow removal of an attribute via removeAttr', ->

      @$el.removeAttr 'someAttr'

      assert.isFalse _.has @el1, 'someAttr'

  describe 'addClass', ->

    it 'should support simple class names', ->

      $(@el1).addClass 'someClass'
      $(@el1).addClass 'someOtherClass'

      assert.equal @el1._class, 'someClass someOtherClass'

    it 'should support space-separated class names', ->

      # This prevents the test from working simply by passing the space-
      # separated string directly to the _class property.
      $(@el1).addClass 'someClass'

      $(@el1).addClass 'someClass someOtherClass'

      assert.equal @el1._class, 'someClass someOtherClass'

  describe 'removeClass', ->

    beforeEach ->
      $(@el1).attr 'class', 'someClass someOtherClass oneMoreClass'

    it 'should support removing a single class', ->

      $(@el1).removeClass 'someOtherClass'

      assert.isTrue $(@el1).hasClass 'someClass'
      assert.isTrue $(@el1).hasClass 'oneMoreClass'

    it 'should support removing multiple space-separated classes', ->

      $(@el1).removeClass 'someOtherClass someClass'

      assert.isTrue $(@el1).hasClass 'oneMoreClass'
      assert.isFalse $(@el1).hasClass 'someClass'

    it 'should support removing all classes', ->

      $(@el1).removeClass()

      assert.isFalse $(@el1).hasClass 'someClass'
      assert.isFalse $(@el1).hasClass 'someOtherClass'
      assert.isFalse $(@el1).hasClass 'oneMoreClass'

  describe 'text', ->

    it 'should handle labels', ->

      $label = $('<Label>').text 'Test Text'

      assert.equal $label[0].text, 'Test Text'

      assert.equal $label.text(), 'Test Text'

    it 'should handle buttons', ->

      $button = $('<Button>').text 'Test Text'

      assert.equal $button[0].title, 'Test Text'

      assert.equal $button.text(), 'Test Text'
