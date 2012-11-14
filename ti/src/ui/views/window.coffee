class TitaniumWindow extends TitaniumView

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

  setLeftNavButton: (@leftNavButton) ->

  setRightNavButton: (@rightNavButton) ->

Ti.UI.createWindow = (attributes) ->

  new TitaniumWindow attributes
