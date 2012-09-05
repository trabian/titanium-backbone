styles = require('styles').ui.form

FieldFactory = require 'views/ui/form/editors/factory'

CollectionView = require 'core/views/collection'

module.exports = class FieldListView extends CollectionView

  attributes: styles.fieldList.view

  getView: (model) ->

    key = "#{model.get 'key'}"

    FieldFactory.build
      field: model
      fieldStyle: @options.fieldStyles?[key]
