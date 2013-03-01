class TitaniumButton extends TitaniumView

  setTitle: (@title) ->

  setEnabled: (@enabled) ->

Ti.UI.createButton = (attributes) ->

  new TitaniumButton attributes

class TitaniumButtonBar extends TitaniumView

  show: -> @visible = true

  hide: -> @visible = false

Ti.UI.createButtonBar = (attributes) ->

  new TitaniumButtonBar attributes
