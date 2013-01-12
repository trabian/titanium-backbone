class TitaniumToolbar extends TitaniumView

  tiClassName: 'TiUIToolbar'

Ti.UI.createToolbar = (attributes) ->

  new TitaniumToolbar attributes

Ti.UI.iOS.createToolbar = (attributes) ->

  new TitaniumToolbar attributes
