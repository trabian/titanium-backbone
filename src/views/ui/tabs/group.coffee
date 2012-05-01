styles = require('styles').ui

Controller = require 'views/controller'

CollectionView = require 'views/base/collection'

Tab = require './tab'

module.exports = class TabGroup extends CollectionView

  viewName: 'TabGroup'

  attributes: ->
    _.extend {}, styles.window.view,
      activeTab: 0

  events:
    close: 'destroy'

  # Internal: Add the tab for the provided presenter.
  addOne: (presenter, options) =>

    tabView = new Tab
      presenter: presenter
      model: @model
      controller: @controller

    @view.addTab tabView.render().view

  _bindControllerEvents: =>

    @controller = new Controller
      context: @

    super

  open: => @view.open()

  close: => @view.close()

  destroy: => @trigger 'destroy'
