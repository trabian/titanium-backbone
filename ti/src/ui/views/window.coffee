class TitaniumWindow extends TitaniumView

  tiClassName: 'TiUIWindow'

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

Ti.UI.createWindow = (attributes) ->

  new TitaniumWindow attributes
