class TitaniumTextArea extends TitaniumView

  tiClassName: 'TiUITextArea'

  setValue: (@value) ->

    @fireEvent 'change',
      value: @value

  getValue: -> @value

Ti.UI.createTextArea = (attributes) ->

  new TitaniumTextArea attributes
