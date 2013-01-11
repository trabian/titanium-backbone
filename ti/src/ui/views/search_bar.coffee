class TitaniumSearchBar extends TitaniumView

  tiClassName: 'TiUISearchBar'

Ti.UI.createSearchBar = (attributes) ->

  new TitaniumSearchBar attributes
