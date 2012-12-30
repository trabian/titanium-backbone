class TitaniumTableView extends TitaniumView

  tiClassName: 'TiUITableView'

  appendRow: (row) ->
    @add row

class TitaniumTableViewRow extends TitaniumView

  tiClassName: 'TiUITableViewRow'

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes
