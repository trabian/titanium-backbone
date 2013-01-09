app = require '../../test.js'
_ = require 'underscore'

app.stitchRequire('tb/lib/backbone-extensions').load()

module.exports =

  Backbone: app.Backbone

  chai: require 'chai'

  require: (path) ->
    app.stitchRequire path
