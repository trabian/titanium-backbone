Chaplin = require 'chaplin'

module.exports = class BaseView extends Chaplin.View

  autoRender: true

  getTemplateFunction: -> @template

  delegateNewEvents: (events) ->
    @_delegateEvents events

  render: ->

    super

    if @bindings
      @stickit()

    @

  # This is different from Chaplin.View::dispose in that it doesn't try to
  # remove the el on disposal.
  dispose: ->
    return if @disposed

    throw new Error('Your `initialize` method must include a super call to
      Chaplin `initialize`') unless @subviews?

    # Dispose subviews
    subview.dispose() for subview in @subviews

    # Unbind handlers of global events
    @unsubscribeAllEvents()

    # Unbind all referenced handlers
    @stopListening()

    # Remove all event handlers on this module
    @off()

    # Remove all event handlers on view
    @undelegateEvents()

    # Remove element references, options,
    # model/collection references and subview lists
    properties = [
      'el', '$el',
      'options', 'model', 'collection',
      'subviews', 'subviewsByName',
      '_callbacks'
    ]
    delete this[prop] for prop in properties

    # Finished
    @disposed = true

    # You’re frozen when your heart’s not open
    Object.freeze? this
