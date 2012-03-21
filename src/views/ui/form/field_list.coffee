FieldFactory = require 'views/ui/form/editors/factory'

CollectionView = require 'views/base/collection'

module.exports = class FieldListView extends CollectionView

  attributes:
    height: 'auto'
    layout: 'vertical'

  addOne: (model) =>

    editor = FieldFactory.build
      field: model
      controller: @controller

    @view.add editor.render().view
