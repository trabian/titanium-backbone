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

    it 'should handle nested styles', (done) ->

      converter.convert @styl, (err, out) ->

        Label = out.Label

        assert.ok Label

        rules = Label.rules

        assert.equal rules.color, '#030'
        assert.equal rules.font?.fontSize, '14px'
        assert.equal rules.font?.fontWeight, 'bold'

        assert.ok Label.selectors

        selectorNode = Label.selectors[0]

        assert.equal selectorNode.selector, 'Window Label'

        rules = selectorNode.rules

        assert.equal rules.height, 50
        # assert.equal rules.font.fontWeight, 'normal'

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
