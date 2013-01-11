class TitaniumWebView extends TitaniumView

  tiClassName: 'TiUIWebView'

Ti.UI.createWebView = (attributes) ->

  new TitaniumWebView attributes
