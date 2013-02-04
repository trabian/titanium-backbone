Chaplin = require 'chaplin'

module.exports = class BaseView extends Chaplin.View

  autoRender: true

  getTemplateFunction: -> @template

  delegateNewEvents: (events) ->
    @_delegateEvents events
