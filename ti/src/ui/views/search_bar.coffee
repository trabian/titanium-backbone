class TitaniumSearchBar extends TitaniumView

  showCancel: false

  blur: ->
    @fireEvent 'blur'

Ti.UI.createSearchBar = (attributes) ->

  new TitaniumSearchBar attributes
