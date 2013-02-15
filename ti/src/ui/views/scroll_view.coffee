class TitaniumScrollView extends TitaniumView

  setContentHeight: ->

Ti.UI.createScrollView = (attributes) ->

  new TitaniumScrollView attributes
