helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ attribute methods', ->

  beforeEach ->
    @el = ti.createView 'View'
    @$el = $ @el

  it 'should be able to set an attribute on a view', ->

    @$el.attr 'left', 10

    assert.equal @el.left, 10

  it 'should be able to access an attribute on a view', ->

    @el.left = 10

    assert.equal @$el.attr('left'), 10

  it 'should be able to set multiple attributes on a view', ->

    @$el.attr
      left: 10
      right: 20

    assert.equal @el.left, 10
    assert.equal @el.right, 20
