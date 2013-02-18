app = require '../../test.js'
_ = require 'underscore'

app.stitchRequire('tb').load()

# Allows sinon.js to work without modification
document.createElement = ->

module.exports =

  Backbone: app.Backbone

  chai: require 'chai'

  sinon: require 'sinon'

  require: (path) ->
    app.stitchRequire path
