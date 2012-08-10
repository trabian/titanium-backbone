class TitaniumTextField extends TitaniumView

  setValue: (@value) ->

    @trigger 'change',
      value: @value

Ti.UI.createTextField = (attributes) ->

  new TitaniumTextField attributes
