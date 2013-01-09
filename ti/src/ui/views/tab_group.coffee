class TitaniumTabGroup extends TitaniumView

  tiClassName: 'TiUITabGroup'

  addTab: (tab) -> @add tab

  getTabs: -> @children

  open: ->

class TitaniumTab extends TitaniumView

  tiClassName: 'TiUITab'

Ti.UI.createTabGroup = (attributes) ->

  new TitaniumTabGroup attributes

Ti.UI.createTab = (attributes) ->

  new TitaniumTab attributes
