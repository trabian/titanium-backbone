helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ traversal methods', ->

  beforeEach ->
    @el = ti.createView 'View'
    @$el = $ @el

  it 'a view appended to an existing view should have a reference to its parent', ->

    @$el.append newEl = ti.createView 'View'

    $newEl = $(newEl)

    assert.equal $newEl.parent()[0], @$el[0]

  it 'should allow traversal via "each"', ->

    @$el.each (el) =>
      assert.equal el, @el

  it 'should allow access via "get"', ->

    assert.equal @$el.get(0), @el

  it 'should return a regular array via "get"', ->

    assert.isFalse @$el.get().each?

  it 'should allow mapping', ->

    first = ti.createView 'View',
      left: 10

    second = ti.createView 'View',
      left: 20

    $coll = $([first, second])

    mapped = $coll.map -> @left

    assert.equal mapped.get(0), 10
    assert.equal mapped.get(1), 20

    assert.equal mapped.get()[0], 10
    assert.equal mapped.get()[1], 20

  it "should allow accessing a view's children", ->

    @$el.append firstChild = ti.createView 'View'
    @$el.append secondChild = ti.createView 'View'

    assert.equal @$el.children()[0], firstChild
    assert.equal @$el.children()[1], secondChild

  describe 'closest()', ->

    beforeEach ->

      @$el.attr 'class', 'someParent'

      @$child = $('<View>')
        .appendTo(@$el)
        .attr('class', 'someChild')

      @$ancestor = $('<View>')
        .append(@$el)
        .attr('class', 'someAncestor')

    it 'should return the current element if it matches the selector', ->
      assert.equal @$child[0], @$child.closest('.someChild')[0]

    it 'should return the parent if it matches the selector', ->
      assert.equal @$el[0], @$child.closest('.someParent')[0]

    it 'should return an ancestor if it matches the selector', ->
      assert.equal @$ancestor[0], @$child.closest('.someAncestor')[0]

    it 'should return an empty array if there is no match', ->
      assert.equal @$child.closest('.noMatch').length, 0

  describe 'is()', ->

    beforeEach ->

      @$el.attr 'class', 'someClass'
      @$el.attr 'id', 'someId'

    it 'should handle class-based selectors', ->
      assert.isTrue @$el.is '.someClass'
      assert.isFalse @$el.is '.notThisClass'

    it 'should handle multiple class-based selectors', ->

      $el = $('<View>').attr 'class', 'someClass someOtherClass'

      assert.isTrue $el.is '.someClass'
      assert.isTrue $el.is '.someOtherClass'

    it 'should handle id-based selectors', ->
      assert.isTrue @$el.is '#someId'
      assert.isFalse @$el.is '#notThisId'

    it 'should handle viewname-based selectors', ->
      assert.isTrue @$el.is 'View'
      assert.isFalse @$el.is 'Window'

    it 'should handle selector combinations', ->
      assert.isTrue @$el.is('View.someClass'), 'Did not handle viewName.class format'
      assert.isTrue @$el.is('View#someId'), 'Did not handle viewName#id format'

    describe 'attribute selectors', ->

      beforeEach ->
        @$el.attr 'someAttr', 'someValue'

      it 'should handle attribute presence selectors', ->
        assert.isFalse @$el.is('[noAttr]')
        assert.isTrue @$el.is('[someAttr]')

      it 'should handle = comparators', ->
        assert.isFalse @$el.is('[noAttr="something"]')

        assert.isTrue @$el.is('View[someAttr="someValue"]')
        assert.isTrue @$el.is("[someAttr='someValue']")

      it 'should handle != comparators', ->

        assert.isFalse @$el.is('[someAttr!="someValue"]')
        assert.isTrue @$el.is('[someAttr!="someOtherValue"]')

      it 'should handle ^= comparators', ->

        assert.isTrue @$el.is('[someAttr^="some"]')
        assert.isFalse @$el.is('[someAttr^="Value"]')

      it 'should handle $= comparators', ->

        assert.isTrue @$el.is('[someAttr$="Value"]')
        assert.isFalse @$el.is('[someAttr$="some"]')

      it "should handle |= comparators", ->

        @$el.attr 'someHyphenatedAttr', 'someValue-test'
        @$el.attr 'someLongAttr', 'someValueWithTest'

        assert.isTrue @$el.is('[someAttr|="someValue"]')
        assert.isTrue @$el.is('[someHyphenatedAttr|="someValue"]')
        assert.isFalse @$el.is('[someLongAttr|="someValue"]')

      describe 'multiple words', ->

        beforeEach ->
          @$el.attr 'someLongAttr', 'some attr with words'

        it 'should handle *= comparators', ->

          assert.isTrue @$el.is('[someLongAttr*="with"]')
          assert.isFalse @$el.is('[someLongAttr*="nope"]')

        it 'should handle ~= comparators', ->

          @$el.attr 'someLongAttr', 'some attr with words'

          assert.isTrue @$el.is('[someLongAttr~="with"]')
          assert.isFalse @$el.is('[someLongAttr~="wit"]')
          assert.isFalse @$el.is('[someLongAttr~="nope"]')

  describe 'find()', ->

    beforeEach ->

      @$el.attr('class', 'someGrandparent')

      @$el.append @firstChild = ti.createView 'ScrollView'
      @$el.append @secondChild = ti.createView 'View'

      $(@firstChild).attr
        id: 'someId'
        class: 'someClass'

      $(@secondChild).attr
        id: 'someOtherId'
        class: 'someClass someOtherClass'

      $(@firstChild).append @grandChild = ti.createView 'Button'
      $(@secondChild).append @otherGrandChild = ti.createView 'Button'

      $(@grandChild).attr
        class: 'someGrandchild'

      $(@otherGrandChild).attr
        class: 'someGrandchild'

    it 'should handle shallow class-based selectors', ->

      $found = @$el.find '.someClass'

      assert.equal $found.length, 2
      assert.equal $found[0], @firstChild
      assert.equal $found[1], @secondChild

    it 'should handle shallow id-based selectors', ->

      $found = @$el.find '#someOtherId'

      assert.equal $found.length, 1
      assert.equal $found[0], @secondChild

    it 'should handle shallow node-based selectors', ->

      $found = $(@firstChild).find 'Button'

      assert.equal $found.length, 1
      assert.equal $found[0], @grandChild

    it 'should handle shallow node- and class-based selectors', ->

      assert.equal $(@firstChild).find('Button.someGrandchild').length, 1
      assert.equal $(@firstChild).find('Button.notPresent').length, 0
      assert.equal @$el.find('View.someClass').length, 1

    it 'should handle deep node-based selector', ->

      $found = @$el.find 'Button'

      assert.equal $found.length, 2

    it 'should handle class-based selectors scoped by parent with id', ->

      $found = @$el.find '#someId .someGrandchild'

      assert.equal $found.length, 1
      assert.equal $found[0], @grandChild

    it 'should handle class-based selectors scoped by parent with class', ->

      $found = @$el.find '.someClass .someGrandchild'

      assert.equal $found.length, 2
      assert.equal $found[0], @grandChild

    it 'should handle class-based selectors scoped by parent with node name', ->

      $found = @$el.find 'ScrollView .someGrandchild'

      assert.equal $found.length, 1
      assert.equal $found[0], @grandChild

    it 'should handle direct parents', ->
      assert.equal @$el.find('.someGrandparent .someGrandchild').length, 2
      assert.equal @$el.find('.someGrandparent > .someGrandchild').length, 0
      assert.equal @$el.find('.someGrandparent > .someClass').length, 2

    it 'should handle multiple selectors', ->

      assert.equal @$el.find('Button, .someClass').length, 4 # Children and Grandchildren will match
      assert.equal @$el.find('Button, .someGrandchild').length, 2 #Grandchildren will match twice but will only return unique

    it 'should combine matching elements from all elements in a collection', ->

      $coll = $ [@firstChild, @secondChild]

      $found = $coll.find 'Button'

      assert.equal $found.length, 2
      assert.include $found.get(), @grandChild
      assert.include $found.get(), @otherGrandChild
