helpers = require '../../../helpers'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

describe '$ manipulation methods', ->

  beforeEach ->
    @el = ti.createView 'View'
    @$el = $ @el

  it 'should be able to append a child view', ->

    @$el.append ti.createView 'View'
    @$el.append ti.createView 'View'

    assert.equal @$el.children().length, 2

  it 'should be able to appendTo an existing view', ->

    $(ti.createView 'View').appendTo @$el

    assert.equal @$el.children().length, 1

  it 'should add a reference to the parent after appending', ->

    $child = $('<View>')
      .appendTo @$el

    assert.ok $child[0].parent, 'Parent reference was not added to appended view'

  it 'should be able to remove child views', ->

    @$el.append newView = ti.createView 'View'
    @$el.append otherView = ti.createView 'View'

    $(newView).remove()

    assert.equal @$el.children().length, 1

    assert.equal @$el.children().get(0), otherView

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

