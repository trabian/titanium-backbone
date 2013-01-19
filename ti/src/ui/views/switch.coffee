class TitaniumSwitch extends TitaniumView

  tiClassName: 'TiUISwitch'

  setValue: (@value) ->

    @fireEvent 'change'
      value: @value

  getValue: -> @value

Ti.UI.createSwitch = (attributes) ->

  new TitaniumSwitch attributes
