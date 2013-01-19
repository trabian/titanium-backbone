app = require '../../test.js'
_ = require 'underscore'

app.stitchRequire('tb').load()

module.exports =

  Backbone: app.Backbone

  chai: require 'chai'

  require: (path) ->
    app.stitchRequire path
