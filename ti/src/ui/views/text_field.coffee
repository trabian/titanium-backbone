class TitaniumTextField extends TitaniumView

  tiClassName: 'TiUITextField'

  setValue: (@value) ->

    @fireEvent 'change'
      value: @value

  getValue: -> @value

Ti.UI.createTextField = (attributes) ->

  new TitaniumTextField attributes
