class TitaniumTabbedBar extends TitaniumView

  tiClassName: 'TiUITabbedBar'

Ti.UI.createTabbedBar = (attributes) ->

  new TitaniumTabbedBar attributes

Ti.UI.iOS.createTabbedBar = (attributes) ->

  new TitaniumTabbedBar attributes
