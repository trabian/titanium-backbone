class TitaniumProgressBar extends TitaniumView

  tiClassName: 'TiUIProgressBar'

Ti.UI.createProgressBar = (attributes) ->

  new TitaniumProgressBar attributes
