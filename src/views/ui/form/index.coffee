styles = require('styles').ui.form

FieldList = require 'presenters/form/field_list'

FormTable = require './table'
FieldListView = require './field_list'

View = require 'views/base'

module.exports = class FormView extends View

  attributes: styles.view

  render: =>

    fieldSections = @presenter.fields.groupBy (field) -> field.get 'section'

    for section in @presenter.get 'sections'

      if fields = fieldSections[section.key]

        listViewClass = if section.group then FormTable else FieldListView

        @add new listViewClass
          controller: @controller
          collection: new FieldList fields
          fieldStyles: @options.fieldStyles

    @
