class TitaniumTabGroup extends TitaniumView

  tiClassName: 'TiUITabGroup'

  constructor: ->
    @tabs = []
    super

  addTab: (tab) ->
    tab.parent = @
    @tabs.push tab

  getTabs: -> @tabs

  removeTab: (tab) ->
    @tabs = _.without @tabs, tab

  open: ->

class TitaniumTab extends TitaniumView

  tiClassName: 'TiUITab'

Ti.UI.createTabGroup = (attributes) ->

  new TitaniumTabGroup attributes

Ti.UI.createTab = (attributes) ->

  new TitaniumTab attributes
