module.exports = class Controller extends Backbone.Model

  initialize: (attributes) ->
    @context = attributes?.context

  show: (name, window, options) =>
    @trigger 'show', name, window, options

  # Alias to 'show'
  open: (name, window, options) =>
    @show arguments

  close: (window, options) =>
    @trigger 'close', window, options
