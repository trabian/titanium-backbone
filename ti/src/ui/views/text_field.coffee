class TitaniumTextField extends TitaniumView

  setValue: (@value) ->

    @trigger 'change',
      value: @value

  setEnabled: (@enabled) ->

Ti.UI.createTextField = (attributes) ->

  new TitaniumTextField attributes
