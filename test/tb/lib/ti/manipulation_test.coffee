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

  it 'should be able to append multiple child views', ->

    view1 = ti.createView 'View'
    view2 = ti.createView 'View'

    @$el.append $ [view1, view2]

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

  it 'should be able to replace all views using "html"', ->

    @$el.append ti.createView 'View'
    @$el.append ti.createView 'View'

    @$el.html ti.createView 'View'

    assert.equal @$el.children().length, 1

    view1 = ti.createView 'View'
    view2 = ti.createView 'View'

    @$el.html $ [view1, view2]

    assert.equal @$el.children().length, 2

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

  describe 'jade support', ->

    beforeEach ->

      template = helpers.require 'fixtures/template'

      @sampleLabelText = 'This is sample label text'

      @$jadeEl = $('<View>').append template
        sampleLabelText: @sampleLabelText

    it 'should support regular views', ->

      $testView = @$jadeEl.find('View.testView')

      assert.ok $testView[0]
      assert.equal $testView.attr('width'), '10'
      assert.equal $testView.children().length, 2

      assert.ok @$jadeEl.find('#someButton')[0]
      assert.equal @$jadeEl.find('Label.myLabel').text(), @sampleLabelText

    it 'should support namespaced views', ->

      $adView = @$jadeEl.find('.someAdView')

      assert.equal $adView[0]._viewName, 'iOS:AdView'
