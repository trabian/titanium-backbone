viewStyles = require('styles/ui/android').actionBar

View = require 'views/base'

ActionsView = require './actions'

module.exports = class ActionBar extends View

  attributes: viewStyles.view

  name: 'action_bar'

  render: ->

    @wrap (view) =>

      view.add title = @make 'Label', viewStyles.title,
        text: @presenter.get 'title'

      @presenterBind 'change:title', =>
        title.text = @presenter.get 'title'

      @add (new ActionsView
        collection: @presenter.get 'actions'
      ), view

      # view.add actionWrapper = @make 'View', viewStyles.actions

      # @presenter.get('actions').each ->

      #   for action in actions

      #     actionWrapper.add actionView = @make 'View', viewStyles.action.view

      #     actionView.add @make 'ImageView', viewStyles.action.image,
      #       image: action.icon

      #     @delegateEventsForView actionView,
      #       click: action.onClick

    @

