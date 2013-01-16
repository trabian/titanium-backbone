helpers = require '../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

Ti = ti.Ti

describe 'XML mock', ->

  beforeEach ->
    @doc = Ti.XML.parseString '<root><View height="10" width="20"><Button height="2">Click Me!</Button><Label height="3">Label Text</Label></View></root>'

  it 'should provide a structure that matches the Titanium.XML API', ->

    assert.equal @doc.childNodes.length, 1
    assert.equal @doc.childNodes.item(0).attributes.length, 2
    assert.equal @doc.childNodes.item(0).attributes.item(1).value, '20'

    assert.equal @doc.childNodes.item(0).textContent, undefined

  it 'should return the view with height of 10 as the first child', ->

    child = @doc.childNodes.item 0

    assert.ok child
    assert.equal child.nodeName, 'View'

    heightAttribute = child.attributes.getNamedItem 'height'

    assert.equal heightAttribute.name, 'height'
    assert.equal heightAttribute.value, '10'

  it 'should provide access to the view child nodes', ->

    view = @doc.childNodes.item(0)

    children = view.childNodes

    assert.equal children.length, 2

    assert.equal children.item(0).nodeName, 'Button'

    assert.equal children.item(0).attributes.item(0).name, 'height'
    assert.equal children.item(0).attributes.item(0).value, '2'

    assert.equal children.item(1).nodeName, 'Label'

  it 'should provide access to the button text', ->

    button = @doc.childNodes.item(0).childNodes.item 0

    assert.equal button.textContent, 'Click Me!'

    node = button.childNodes.item 0

    assert.ok node.nodeType
    assert.equal node.nodeType, node.TEXT_NODE
    assert.equal node.nodeValue, 'Click Me!'

  it 'should add the namespace to the nodeName', ->

    namespacedDoc = Ti.XML.parseString '<root xmlns:iPhone="tb.iPhone"><iPhone:NavigationGroup height="20" /></root>'

    assert.equal namespacedDoc.childNodes.item(0).nodeName, 'iPhone:NavigationGroup'





