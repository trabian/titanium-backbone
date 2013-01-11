class TitaniumActivityIndicator extends TitaniumView

  tiClassName: 'TiUIActivityIndicator'

Ti.UI.createActivityIndicator = (attributes) ->

  new TitaniumActivityIndicator attributes
