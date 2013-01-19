class TitaniumSlider extends TitaniumView

  tiClassName: 'TiUISlider'

  setValue: (@value) ->

    @fireEvent 'change'
      value: @value

  getValue: -> @value

Ti.UI.createSlider = (attributes) ->

  new TitaniumSlider attributes
