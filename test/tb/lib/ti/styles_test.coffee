helpers = require '../../../helpers'
_ = require 'underscore'

{ assert } = helpers.chai

ti = helpers.require 'tb/lib/ti'
$ = ti.$

styler = helpers.require 'tb/lib/styler'

describe 'CSS styling', ->

  afterEach ->
    styler.reset()

  it 'should handle shallow selectors for windows', ->

    styler.load
      "Window":
        rules:
          height: 20

    assert.equal $('<Window>').attr('height'), 20

    styler.reset()

  describe 'nested selectors', ->

    beforeEach ->

      styler.load
        "Label":
          rules:
            height: 10

          selectors: [
            selector: '.container Label'
            rules:
              height: 20
          ,
            selector: '.non-existent-container Label'
            rules:
              width: 20
          ,
            selector: '.error'
            rules:
              color: '#600'
          ,
            selector: '.nested .container Label'
            rules:
              height: 30
          ]

    it 'should apply the styles when the view is added to a window via appendTo', ->

      $label = $('<Label class="error" />')

      assert.equal $label.attr('height'), undefined

      $label.appendTo '<Window>'

      assert.equal $label.attr('height'), 10

    it 'should apply the styles when the view is added to a window via html', ->

      $win = $('<Window>')

      $win.html '<Label class="error">'

      assert.equal $win.find('Label').attr('height'), 10

    it 'should apply the styles when the view is added to a view that is already attached to a window', ->

      $childView = $('<View><Label class="error" /></View>')

      $view = $('<View class="container">').appendTo '<Window>'

      $label = $childView.find 'Label'

      assert.equal $label.attr('height'), undefined
      assert.equal $label.attr('color'), undefined

      $childView.appendTo $view

      assert.equal $label.attr('height'), 20
      assert.equal $label.attr('width'), undefined
      assert.equal $label.attr('color'), '#600'

    it 'should apply the styles when the container is added to a window', ->

      $label = $('<Label class="error" />')

      $view = $('<View class="container">')

      $label.appendTo $view

      assert.equal $label.attr('height'), undefined
      assert.equal $label.attr('color'), undefined

      $view.appendTo '<Window class="nested">'

      assert.equal $label.attr('height'), 30

  describe 'nested views', ->

    beforeEach ->
      styler.load
        View:

          selectors: [
            selector: '.top'
            rules:
              height: 20
          ,
            selector: '.inner'
            rules:
              height: 30
          ]

    it 'should handle nested views', ->

      $win = $('<Window><View class="top"><View class="inner" /></View></Window>')

      assert.equal $win.find('.top').attr('height'), 20
      assert.equal $win.find('.inner').attr('height'), 30

  describe 'cascading', ->

    beforeEach ->

      styler.load
        "Label":

          rules:
            height: 10
            color: '#333'

          selectors: [
            selector: '.level1 .level2 Label'
            rules:
              height: 30
          ,
            selector: '.level2 Label'
            rules:
              height: 20
              color: '#666'
          ,
            selector: '.error'
            rules:
              color:
                value: '#900'
                important: true
          ]

        "View":

          rules:
            backgroundColor: '#eee'

    it 'should give priority to the highest level of nesting', ->

      level1 = $('<Window class="level1">')[0]

      level2 = $('<View class="level2">')[0]
      level2.parent = level1

      label = $('<Label>')[0]
      label.parent = level2

      assert.equal styler.stylesForView(label).height, 30

      assert.equal styler.stylesForView(level2).backgroundColor, '#eee'

    it 'should give priority to "important" rules', ->

      $parent = $('<View class="level2">')
        .appendTo '<Window class="level1">'

      label = $('<Label class="error">')[0]
      label.parent = $parent[0]

      assert.equal styler.stylesForView(label).color, '#900'

    it 'should keep the inline attributes for non-important attributes', ->

      $parent = $('<View class="level2">')
        .appendTo '<Window class="level1">'

      label = $('<Label class="error" height="50" color="#000">')[0]

      label.parent = $parent[0]

      styles = styler.stylesForView label

      assert.equal styles.color, '#900'
      assert.equal styles.height, undefined
      assert.equal label.height, 50
