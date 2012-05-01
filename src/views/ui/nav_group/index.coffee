styles = require('styles').ui

Controller = require 'views/controller'

View = require 'views/base'

module.exports = class NavGroup extends View

  viewName: 'iPhone::NavigationGroup'

  attributes: styles.window.view

  initialize: ->
    @initializeController()

  initializeController: ->

    @controller = new Controller

    @controller.on 'show', (name, window, options) =>

      @controller.context = window

      if options?.modal or window.view.modal

        # Open the window
        window.render().open
          modal: true

      else

        # Open the window in the current tab.
        @view.open window.render().view

  render: =>

    viewClass = @presenter.get 'viewClass'

    window = new viewClass _.extend {}, @presenter.get('options') or {},
      controller: @controller
      model: @model

    @view.window = window.render().view

    @
