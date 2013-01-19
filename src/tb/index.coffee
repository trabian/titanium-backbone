module.exports =

  load: ->

    Backbone.$ = require('./lib/ti').$

    _.extend Backbone.Stickit, require './lib/stickit'

    $: Backbone.$
