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

    assert.ok $('<iPhone:NavigationGroup>')[0]

  it 'should return an empty array if the argument is undefined', ->
    assert.equal $(undefined).length, 0

  describe 'XML element creation', ->

    it 'should support shallow views with attributes', ->

      view = $('<View height="20" width="30" class="someClass">')[0]

      assert.equal view._viewName, 'View'
      assert.equal view.height, '20'
      assert.equal view.width, '30'
      assert.equal view._class, 'someClass'
      assert.equal view.class, undefined

    it 'should support shallow views with text', ->

      label = $('<Label>This is some text!</Label>')[0]

      assert.equal label._viewName, 'Label'
      assert.equal label.text, 'This is some text!'

    it 'should support nested views', ->

      $view = $('<View><View><Button>Click Me!</Button></View></View>')

      assert.ok $view.find('View')[0]

      button = $view.find('Button')[0]

      assert.ok button
      assert.equal button._viewName, 'Button'
      assert.equal button.title, 'Click Me!'

    it 'should support namespaced views with attributes', ->

      for viewName in ['iPhone:NavigationGroup', 'iOS:AdView', 'iPad:SplitWindow']

        view = $("<#{viewName} backgroundColor='#333' />")[0]
        assert.ok view

