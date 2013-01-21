helpers = require '../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

styler = helpers.require 'tb/lib/styler'

describe 'CSS styling', ->

  afterEach ->
    styler.reset()

  it 'should handle shallow selectors', ->

    styler.load
      "Label":
        height: 20

    assert.equal $('<Label>').attr('height'), 20

    styler.reset()

  describe 'nested selectors', ->

    beforeEach ->

      styler.load
        ".container Label":
          height: 20

    it 'should work with nested elements created at one time', ->
      assert.equal $('<Label>').attr('height'), undefined
      assert.equal $('<View class="container"><Label /></View>').find('Label').attr('height'), 20

    it 'should handle appension after the fact', ->

      $label = $('<Label>')
      $view = $('<View class="container">')

      $view.append $label

      assert.equal $label.attr('height'), 20


