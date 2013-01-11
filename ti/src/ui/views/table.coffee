class TitaniumTableView extends TitaniumView

  constructor: ->
    @rows = []
    @sections = []
    super

  tiClassName: 'TiUITableView'

  add: (view) ->
    throw new Error 'Rows can not be added to tables via `add`'

  appendRow: (row) ->
    row.parent = @
    @rows.push row

  deleteRow: (index) ->

    row = @rows[index]

    if section = row._section
      section.rows = _.without section.rows, row

    @rows = _.without @rows, row

  appendSection: (section) ->
    section.parent = @
    @sections.push section

  deleteSection: (index) ->
    @sections = _.without @sections, @sections[index]

class TitaniumTableViewRow extends TitaniumView

  tiClassName: 'TiUITableViewRow'

class TitaniumTableViewSection extends TitaniumView

  tiClassName: 'TiUITableViewSection'

  constructor: ->
    @rows = []
    super

  add: (row) ->
    row.parent = @
    row._section = @
    @rows.push row
    @parent.appendRow row

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes

Ti.UI.createTableViewSection = (attributes) ->

  new TitaniumTableViewSection attributes
