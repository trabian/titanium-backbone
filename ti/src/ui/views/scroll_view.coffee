class TitaniumScrollView extends TitaniumView

  tiClassName: 'TiUIScrollView'

Ti.UI.createScrollView = (attributes) ->

  new TitaniumScrollView attributes
