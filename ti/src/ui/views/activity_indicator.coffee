class TitaniumActivityIndicator extends TitaniumView

  show: ->
    @visible = true

  hide: ->
    @visible = false

Ti.UI.createActivityIndicator = (attributes) ->

  new TitaniumActivityIndicator attributes
