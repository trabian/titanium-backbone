class TitaniumSearchBar extends TitaniumView

  tiClassName: 'TiUISearchBar'

  setValue: (@value) ->

    @fireEvent 'change'
      value: @value

  getValue: -> @value

Ti.UI.createSearchBar = (attributes) ->

  new TitaniumSearchBar attributes
