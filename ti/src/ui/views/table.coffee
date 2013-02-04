class TitaniumTableView extends TitaniumView

  appendRow: (row) ->
    @add row

  deleteRow: (row) ->

  setData: (@data) ->

  setFooterView: (@footerView) ->

class TitaniumTableViewRow extends TitaniumView

  setHasChild: (@hasChild) ->

Ti.UI.createTableView = (attributes) ->

  new TitaniumTableView attributes

Ti.UI.createTableViewRow = (attributes) ->

  new TitaniumTableViewRow attributes
