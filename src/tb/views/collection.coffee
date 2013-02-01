Chaplin = require 'chaplin'

module.exports = class CollectionView extends Chaplin.CollectionView

  animationDuration: 0

  getTemplateFunction: -> @template or ->

  filterCallback: (view, included) ->
