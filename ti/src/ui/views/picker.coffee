class TitaniumPicker extends TitaniumView

  constructor: ->
    @columns = []
    super

  tiClassName: 'TiUIPicker'

  add: (view) ->

    if view._viewName is 'PickerRow'

      unless column = @columns?[0]
        column = Ti.UI.createPickerColumn()
        @columns.push column

      column.addRow view

    else
      view.parent = @
      @columns.push view

  setColumns: (@columns) ->

class TitaniumPickerColumn extends TitaniumView

  constructor: ->
    @rows = []
    super

  tiClassName: 'TiUIPickerColumn'

  add: (view) ->
    throw new Error 'Rows can not be added to picker columns via `add`'

  addRow: (row) ->
    row.parent = @
    @rows.push row

  removeRow: (row) ->
    @rows = _.without @rows, row

  appendSection: (section) ->
    section.parent = @
    @sections.push section

  deleteSection: (index) ->
    @sections = _.without @sections, @sections[index]

class TitaniumPickerRow extends TitaniumView

  tiClassName: 'TiUIPickerRow'

Ti.UI.createPicker = (attributes) ->

  new TitaniumPicker attributes

Ti.UI.createPickerColumn = (attributes) ->

  new TitaniumPickerColumn attributes

Ti.UI.createPickerRow = (attributes) ->

  new TitaniumPickerRow attributes
