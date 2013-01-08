helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ attribute methods', ->

  beforeEach ->

    @el1 = ti.createView 'View'
    @el2 = ti.createView 'View'

    @$coll = $ [@el1, @el2]

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
