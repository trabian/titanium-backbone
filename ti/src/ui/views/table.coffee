class TitaniumTableView extends TitaniumView

  appendRow: (row) ->
    @add row

  deleteRow: (row) ->

  setData: (@data) ->

class TitaniumTableViewRow extends TitaniumView

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes
