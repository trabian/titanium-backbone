helpers = require '../../../helpers'

{ assert } = helpers.chai

describe 'Chaplin inclusion', ->

  it 'should be available', ->

    assert.ok helpers.require 'chaplin'
