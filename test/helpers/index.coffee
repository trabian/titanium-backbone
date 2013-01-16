app = require '../../test.js'
_ = require 'underscore'

app.Backbone.$ = app.stitchRequire('tb').$

module.exports =

  Backbone: app.Backbone

  chai: require 'chai'

  require: (path) ->
    app.stitchRequire path
