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

      @add (actionsView = new ActionsView
        collection: @presenter.get 'actions'
      ), view

      @bindToAndTrigger @presenter, 'add:actions remove:actions', =>

        _.defer ->
          title.right = actionsView.view.size.width + 10

    @

