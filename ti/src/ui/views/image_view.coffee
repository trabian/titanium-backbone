class TitaniumImageView extends TitaniumView

  tiClassName: 'TiUIImageView'

Ti.UI.createImageView = (attributes) ->

  new TitaniumImageView attributes
