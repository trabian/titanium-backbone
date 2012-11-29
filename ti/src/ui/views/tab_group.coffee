class TitaniumTabGroup extends TitaniumView

  addTab: (tab) -> @add tab

  getTabs: -> @children

  setTabs: (@children) ->

  open: ->

class TitaniumTab extends TitaniumView

  setWindow: (@window) ->

Ti.UI.createTabGroup = (attributes) ->

  new TitaniumTabGroup attributes

Ti.UI.createTab = (attributes) ->

  new TitaniumTab attributes
