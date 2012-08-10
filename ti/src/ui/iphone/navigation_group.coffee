class TitaniumNavigationGroup extends TitaniumView

  open: ->
    @trigger 'open'

  close: ->
    @trigger 'close'

Ti.UI.iPhone.createNavigationGroup = (attributes) ->

  new TitaniumNavigationGroup attributes


