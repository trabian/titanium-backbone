class TitaniumWindow extends TitaniumView

  tiClassName: 'TiUIWindow'

  bubbleParent: false

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

Ti.UI.createWindow = (attributes) ->

  new TitaniumWindow attributes
