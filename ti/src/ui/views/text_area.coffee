class TitaniumTextArea extends TitaniumView

  tiClassName: 'TiUITextArea'

Ti.UI.createTextArea = (attributes) ->

  new TitaniumTextArea attributes
