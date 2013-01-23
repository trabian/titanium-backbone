styl = '''
Label
  color: #030
Window
  height 30
  width 40
  .error
    color: #f00
  Label
    width 40
  Label, Button, .has-text
    font: 14px solid blue
    height: 20
    &.error
      color: #600
'''

helpers = require '../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

converter = require '../../lib/styles/converter'

ti = helpers.require 'tb/lib/ti'

Ti = ti.Ti

describe 'The stylus converter', ->

  it 'should handle shallow styles', ->

    styl = '''
    Label
      color #030
      height 40
    '''

    out = converter.convert(styl)

    assert.ok out.Label

    assert.equal out.Label.rules?.color, '#030'
    assert.equal out.Label.rules?.height, 40

  it 'should handle shared styles', ->

    styl = '''
    Label, Button
      color #030
      height 40
    '''

    out = converter.convert(styl)

    assert.ok out.Label

    assert.equal out.Label.rules?.color, '#030', 'Label styles were not loaded'
    assert.equal out.Label.rules?.height, 40

    assert.equal out.Button.rules?.color, '#030', 'Button styles were not loaded'
    assert.equal out.Button.rules?.height, 40

  describe "complex styles", ->

    beforeEach ->

      @styl = '''

      Ti(keys)
        unquote(keys)

      Label
        color #030
        font 14px bold
      TextField
        width unquote('Ti.UI.FILL')
        font 14
      Window
        Label
          height 50
          font-weight normal
          &.error
            color #300 !important
      '''

    it 'should handle multiple styles on a node', ->

      styl = '''
      Window
        View, Button
          height 44
        Label
          height 50
          font-weight normal
          &.error
            color #300 !important
      '''

      out = converter.convert styl

      Label = out.Label

      selectorNode = _.find Label.selectors, (selectorNode) -> selectorNode.selector is 'Window Label'

      assert.ok selectorNode
      assert.equal selectorNode.selector, 'Window Label'

      rules = selectorNode.rules

      assert.ok rules
      assert.equal rules.height, 50
      assert.equal rules.font.fontWeight, 'normal'

    it 'should handle extended styles', ->

      styl = '''

        TextField
          &.tall
            height: 100

        Label
          &.full
            width: 30
          &.heading
            @extend Label.full
            width: 40
        TextField
          @extend TextField.tall
          width: 40

      '''

      { Label, TextField } = converter.convert styl

      fullSelector = _.find Label.selectors, (sel) ->
        sel.selector is 'Label.full'

      assert.equal fullSelector.rules.width, 30

      headingSelector = _.find Label.selectors, (sel) ->
        sel.selector is 'Label.heading'

      assert.equal headingSelector.rules.width, 40

      assert.equal TextField.rules.width, 40
      assert.equal TextField.rules.height, 100

    it 'should combine styles where possible', ->

      styl = '''
        Label
          &.blue
            color #003
          &.red
            color #300
          &.red, &.blue
            height 20
      '''

      out = converter.convert styl

      Label = out.Label

      selectorNode = _.find Label.selectors, (selectorNode) -> selectorNode.selector is 'Label.blue'

      assert.ok selectorNode

      assert.ok selectorNode.rules.color
      assert.ok selectorNode.rules.height

    it 'should handle nested styles', (done) ->

      converter.convert @styl, (err, out) ->

        Label = out.Label

        assert.ok Label

        rules = Label.rules

        assert.equal rules.color, '#030'
        assert.equal rules.font?.fontSize, '14px'
        assert.equal rules.font?.fontWeight, 'bold'

        assert.ok Label.selectors

        selectorNode = _.find Label.selectors, (selectorNode) -> selectorNode.selector is 'Window Label'

        assert.ok selectorNode
        assert.equal selectorNode.selector, 'Window Label'

        rules = selectorNode.rules

        assert.ok rules
        assert.equal rules.height, 50
        assert.equal rules.font.fontWeight, 'normal'

        done()

    it 'should handle Titanium styles', ->

      out = converter.convert @styl

      TextField = out.TextField

      assert.equal TextField.rules.width, 'Ti.UI.FILL'
      assert.equal TextField.rules.font.fontSize, '14'

    it 'should handle added classes', (done) ->

      converter.convert @styl, (err, out) ->

        Label = out.Label

        errorNode = _.find Label.selectors, (node) ->
          node.selector is 'Window Label.error'

        assert.ok errorNode

        assert.equal errorNode.rules.color.value, '#300'
        assert.isTrue errorNode.rules.color.important

        done()

  describe 'font styles', ->

    it 'should split the "font" tag into its component pieces', ->

      out = converter.convert '''
        Label
          font: 20px bold
      '''

      fontRule = out.Label.rules.font

      assert.ok fontRule

      assert.equal fontRule.fontSize, '20px'
      assert.equal fontRule.fontWeight, 'bold'

    it 'should split handle !important in the font tag', ->

      out = converter.convert '''
        Label
          font: 20px bold !important
      '''

      fontRule = out.Label.rules.font

      assert.ok fontRule.value
      assert.isTrue fontRule.important

      assert.equal fontRule.value.fontSize, '20px'
      assert.equal fontRule.value.fontWeight, 'bold'

    it 'should handle font-weight', ->

      out = converter.convert '''
        Label
          font-weight: bold
      '''

      fontRule = out.Label.rules.font

      assert.ok fontRule

      assert.equal fontRule.fontWeight, 'bold'

    it 'should handle font-size', ->

      out = converter.convert '''
        Label
          font-size: 20px
      '''

      fontRule = out.Label.rules.font

      assert.ok fontRule

      assert.equal fontRule.fontSize, '20px'
