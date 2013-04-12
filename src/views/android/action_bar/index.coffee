viewStyles = require('styles/ui/android').actionBar

View = require 'views/base'

ActionsView = require './actions'

module.exports = class ActionBar extends View

  attributes: viewStyles.view

  name: 'action_bar'

  render: ->

    @wrap (view) =>

      view.add @make 'ImageView', viewStyles.icon

      view.add titleWrapper = @make 'View', viewStyles.titleWrapper

      titleWrapper.add title = @make 'Label', viewStyles.title,
        text: @presenter.get 'title'

      title.setWordWrap false

      @presenterBind 'change:title', =>
        title.text = @presenter.get 'title'

      @add (actionsView = new ActionsView
        collection: @presenter.get 'actions'
      ), view

      @bindToAndTrigger @presenter, 'add:actions remove:actions', =>

        _.defer ->
          titleWrapper.setRight actionsView.view.size.width + 10
          super

    @

