class TitaniumLabel extends TitaniumView

  tiClassName: 'TiUILabel'

Ti.UI.createLabel = (attributes) ->

  new TitaniumLabel attributes
