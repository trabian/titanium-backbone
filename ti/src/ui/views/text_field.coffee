class TitaniumTextField extends TitaniumView

  tiClassName: 'TiUITextField'

  setValue: (@value) ->

    @trigger 'change',
      value: @value

Ti.UI.createTextField = (attributes) ->

  new TitaniumTextField attributes
