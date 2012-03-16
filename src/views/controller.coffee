module.exports = class Controller extends Backbone.Model

  show: (name, window, className, options) =>
    @trigger 'show', name, window, className, options

  # Alias to 'show'
  open: (name, window, className, options) =>
    @show arguments

  close: (window, options) =>
    @trigger 'close', window, options
