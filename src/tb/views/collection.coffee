Chaplin = require 'chaplin'

module.exports = class CollectionView extends Chaplin.CollectionView

  # Prevent Chaplin's default animation, which tries to use the non-existent
  # $.css
  animationDuration: 0

  getTemplateFunction: -> @template or ->

  filterCallback: (view, included) ->

  delegateNewEvents: (events) ->
    @_delegateEvents events
