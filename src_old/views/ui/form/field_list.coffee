styles = require('styles').ui.form

FieldFactory = require 'views/ui/form/editors/factory'

CollectionView = require 'views/base/collection'

module.exports = class FieldListView extends CollectionView

  attributes: styles.fieldList.view

  addOne: (model) =>

    key = "#{model.get 'key'}"

    # console.log @options.fieldStyles, @options.fieldStyles[key]

    @add FieldFactory.build
      field: model
      controller: @controller
      fieldStyle: @options.fieldStyles?[key]
