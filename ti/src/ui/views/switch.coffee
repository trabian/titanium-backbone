class TitaniumSwitch extends TitaniumView

  tiClassName: 'TiUISwitch'

Ti.UI.createSwitch = (attributes) ->

  new TitaniumSwitch attributes
