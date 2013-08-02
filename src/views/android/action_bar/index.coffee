viewStyles = require('styles/ui/android').actionBar

View = require 'views/base'

ActionsView = require './actions'

TITLE_RIGHT_MARGIN = 10

module.exports = class ActionBar extends View

  attributes: viewStyles.view

  name: 'action_bar'

  render: ->

    @wrap (view) =>

      view.add @make 'ImageView', viewStyles.icon

      titleRight = if actionsWidth = @presenter.get 'actionsWidth'
        console.warn 'ACTIONS WIDTH', actionsWidth
        actionsWidth + TITLE_RIGHT_MARGIN
      else
        0

      view.add titleWrapper = @make 'View', viewStyles.titleWrapper,
        right: titleRight

      titleWrapper.add title = @make 'Label', viewStyles.title,
        text: @presenter.get 'title'

      title.setWordWrap false

      @presenterBind 'change:title', =>
        title.text = @presenter.get 'title'

      @add (actionsView = new ActionsView
        collection: @presenter.get 'actions'
      ), view

      @bindTo actionsView, 'changeWidth', (width) ->
        titleWrapper.setRight width + TITLE_RIGHT_MARGIN

      # updateTitleWidth = ->
      #   console.warn 'set title width'
      #   titleWrapper.setRight actionsView.view.size.width + 10

      # @bindToAndTrigger @presenter, 'add:actions remove:actions', =>

      #   _.defer ->
      #     updateTitleWidth()
      #     super

      # updateTitleWidth()

    @

