class TitaniumTabGroup extends TitaniumView

  addTab: (tab) -> @add tab

  getTabs: -> @children

  open: ->

class TitaniumTab extends TitaniumView

Ti.UI.createTabGroup = (attributes) ->

  new TitaniumTabGroup attributes

Ti.UI.createTab = (attributes) ->

  new TitaniumTab attributes
