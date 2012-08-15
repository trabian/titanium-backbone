class TitaniumTableView extends TitaniumView

  appendRow: (row) ->
    @add row

class TitaniumTableViewRow extends TitaniumView

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes
