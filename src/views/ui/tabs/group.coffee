styles = require('styles').ui

Controller = require 'views/controller'

CollectionView = require 'views/base/collection'

Tab = require './tab'

module.exports = class TabGroup extends CollectionView

  viewName: 'TabGroup'

  attributes: styles.window.view

  events:
    close: 'destroy'

  # Internal: Add the tab for the provided presenter.
  addOne: (presenter) =>

    tabView = new Tab
      presenter: presenter
      controller: @controller

    @view.addTab tabView.render().view

  _bindControllerEvents: =>

    @controller = new Controller
      context: @

    super

  open: => @view.open()

  close: => @view.close()

  destroy: => @trigger 'destroy'
