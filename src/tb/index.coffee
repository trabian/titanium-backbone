module.exports =

  load: (options = {}) ->

    Backbone.$ = require('./lib/ti').$

    _.extend Backbone.Stickit, require './lib/stickit'

    if options.styles
      require('./lib/styler').load options.styles

    $: Backbone.$
