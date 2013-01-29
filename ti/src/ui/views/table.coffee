class TitaniumTableView extends TitaniumView

  constructor: ->
    @data = []
    @sections = []
    super

  tiClassName: 'TiUITableView'

  add: (view) ->
    throw new Error 'Rows can not be added to tables via `add`'

  appendRow: (row) ->

    unless @data.length

      defaultSection = new TitaniumTableViewSection

      defaultSection.parent = @

      @data.push defaultSection
      @sections.push defaultSection

    @data[0].add row

  deleteRow: (indexOrRow) ->

    if _.isNumber indexOrRow
      # Perhaps add handling later?

    else
      @data[0]?._remove indexOrRow

  appendSection: (section) ->
    section.parent = @
    @data.push section
    @sections.push section

  deleteSection: (indexOrSection) ->

    section = if _.isNumber indexOrSection
      @sections[indexOrSection]
    else
      indexOrSection

    @data = _.without @data, section
    @sections = _.without @sections, section

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

  _remove: (row) ->
    @rows = _.without @rows, row

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes

Ti.UI.createTableViewSection = (attributes) ->

  new TitaniumTableViewSection attributes
