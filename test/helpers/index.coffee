app = require '../../test.js'
_ = require 'underscore'

module.exports =

  Backbone: app.Backbone

  chai: require 'chai'

  require: (path) ->
    app.require path
