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

    it 'should handle id-based selectors', ->
      assert.isTrue @$el.is '#someId'
      assert.isFalse @$el.is '#notThisId'

    it 'should handle viewname-based selectors', ->
      assert.isTrue @$el.is 'View'
      assert.isFalse @$el.is 'Window'

