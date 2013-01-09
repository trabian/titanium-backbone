CollectionView = require 'views/base/collection'

DEFAULT_ROW_HEIGHT = 44

module.exports = class Table extends CollectionView

  viewName: 'TableView'

  # Internal: Add a new row to the table.
  addOne: (model) =>

    @add (new @options.rowClass
      model: model
      controller: @controller
    ), @view, 'appendRow'
