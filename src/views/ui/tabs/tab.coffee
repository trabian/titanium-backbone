Controller = require 'views/controller'

View = require 'views/base'

module.exports = class Tab extends View

  viewName: 'Tab'

  attributes: =>
    title: @presenter.get 'title'
    icon: "images/#{@presenter.get 'icon'}"

  initialize: ->
    @_initializeController()

  # Public: Render and return the Tab view.
  render: =>

    @view.window = @_renderWindow()

    @

  # Internal: Build a controller to be passed to all
  # views created within this tab. To open a child,
  # non-modal window within this tab, do:
  #
  #   windowView = new WindowView
  #     # Not strictly necessary but gives the new
  #     # window a reference to the controller that
  #     # it can use to open additional windows.
  #     controller: @controller
  #
  #   @controller.show 'theViewName', windowView
  #
  _initializeController: =>

    @controller = new Controller

    @bindTo @controller, 'show', (name, window) =>

      @controller.context = window

      # Open the window in the current tab.
      @view.open window.render().view

  # Internal: Create a window using the presenter's
  # 'viewClass' attribute with the presenter's 'title'
  # attribute as the title.
  #
  # Returns the rendered window.
  _renderWindow: =>

    window = new (@presenter.get 'viewClass')
      controller: @controller
      style:
        title: @presenter.get 'title'

    window.render().view
