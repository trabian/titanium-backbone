class TitaniumWindow extends TitaniumView

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

Ti.UI.createWindow = (attributes) ->

  new TitaniumWindow attributes
