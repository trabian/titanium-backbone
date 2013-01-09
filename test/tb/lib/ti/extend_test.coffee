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

  it 'should return the original extended collection if provided', ->
    assert.equal @$el, $ @$el

  it 'should allow creation of a new view by passing a string', ->
    assert.equal $('<View>')[0].toString(), '[object TiUIView]'
    assert.equal $('<View/>')[0].toString(), '[object TiUIView]'
    assert.equal $('<View />')[0].toString(), '[object TiUIView]'

    assert.equal $('<View>')[0]._viewName, 'View'

    assert.ok $('<iPhone::NavigationGroup>')[0]

  it 'should return an empty array if the argument is undefined', ->
    assert.equal $(undefined).length, 0
