CollectionView = require 'views/base/collection'

DEFAULT_ROW_HEIGHT = 44

module.exports = class Table extends CollectionView

  viewName: 'TableView'

  # Internal: Add a new row to the table.
  addOne: (model) =>

    row = new @options.rowClass
      model: model
      controller: @controller

    rowView = row.render().view

    @view.appendRow rowView

    @adjustHeight rowView if @options.autoHeight

  # Internal: Adjust the height of the table view to accommodate
  # the new row.
  adjustHeight: (rowView) =>
    @view.height ?= 0
    @view.height += rowView.height or DEFAULT_ROW_HEIGHT
