class TitaniumButton extends TitaniumView

  tiClassName: 'TiUIButton'

Ti.UI.createButton = (attributes) ->

  new TitaniumButton attributes

class TitaniumButtonBar extends TitaniumView

Ti.UI.createButtonBar = (attributes) ->

  new TitaniumButtonBar attributes
