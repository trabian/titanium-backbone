styles = require('styles').ui

CollectionView = require 'views/base/collection'

Tab = require './tab'

module.exports = class TabGroup extends CollectionView

  viewName: 'TabGroup'

  # Internal: Add the tab for the provided presenter.
  addOne: (presenter) =>

    tabView = new Tab { presenter }

    @view.addTab tabView.render().view

  open: => @view.open()

  close: => @view.close()
