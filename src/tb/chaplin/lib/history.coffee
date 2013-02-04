module.exports = class History

  constructor: ->
    @handlers = []

  start: (options) ->

    @options = _({}).extend
      path: ''
    , @options, options

    @path = @options.path

    @loadUrl() unless @options.silent

  loadUrl: (path, options) ->

    path ?= @path

    matched = _.any @handlers, (handler) =>

      if handler.route.test path
        handler.callback path, options
        return true

    matched

  navigate: (@path, options) ->

    @loadUrl @path, options
