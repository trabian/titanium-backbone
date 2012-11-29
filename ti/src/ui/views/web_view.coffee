class TitaniumWebView extends TitaniumView

  canGoBack: -> true
  canGoForward: -> true

  goBack: ->
  goForward: ->

Ti.UI.createWebView = (attributes) ->

  new TitaniumWebView attributes
