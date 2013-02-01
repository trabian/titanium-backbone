helpers = require '../../../helpers'

{ assert } = helpers.chai

Chaplin = helpers.require 'chaplin'

describe 'Chaplin view', ->

  it 'should support autoRender', ->

    class ViewWithoutAutoRender extends Chaplin.View

      render: ->
        @$el.html "<Label>"
        @

    class ViewWithAutoRender extends Chaplin.View

      autoRender: true

      render: ->
        @$el.html "<Label>"
        @

    assert.equal (new ViewWithoutAutoRender).$el.find('Label').length, 0

    assert.equal (new ViewWithAutoRender).$el.find('Label').length, 1
