class TitaniumTextArea extends TitaniumView

  setValue: (@value) ->

    @trigger 'change',
      value: @value

Ti.UI.createTextArea = (attributes) ->

  new TitaniumTextArea attributes
