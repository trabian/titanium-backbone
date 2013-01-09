styles = require('styles').ui.form.table.row

FieldFactory = require 'views/ui/form/editors/factory'

Row = require 'views/ui/table/row'

Label = require 'views/ui/label'

module.exports = class FormTableRow extends Row

  attributes: styles.view

  render: =>

    @view.add @title = @renderLabel()

    @view.add @editor = @renderEditor()

    @

  renderLabel: =>

    label = new Label
      label: @model.get 'label'
      style: styles.label.view
      labelStyle: styles.label.label
      controller: @controller

    label.render().view

  renderEditor: =>

    editorWrapper = @make 'View', styles.editor

    editor = FieldFactory.build
      field: @model
      controller: @controller

    editorWrapper.add editor.render().view

    editorWrapper
