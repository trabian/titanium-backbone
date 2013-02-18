Chaplin = require 'chaplin'

module.exports = class CollectionView extends Chaplin.CollectionView

  # Prevent Chaplin's default animation, which tries to use the non-existent
  # $.css
  animationDuration: 0

  getTemplateFunction: -> @template or ->

  filterCallback: (view, included) ->

  delegateNewEvents: (events) ->
    @_delegateEvents events

  # If the collection view is within a ScrollView then the ScrollView needs to
  # have its height reset after items are added. If there isn't a ScrollView
  # then this will be a noop.
  resizeScrollView: ->

    @findScrollView ?= _.once =>
      @_scrollView = @$list.parents 'ScrollView'

    @findScrollView().attr height: Ti.UI.SIZE

  itemAdded: ->
    super
    @resizeScrollView()

  itemsResetted: ->
    super
    @resizeScrollView()
