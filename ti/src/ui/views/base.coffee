class TitaniumView

  constructor: (attributes) ->
    for name, value of attributes
      @[name] = value
    @children = []

  addEventListener: (name, event) ->
    @on name, event

  fireEvent: (name, event) ->
    @trigger name, event

  add: (view) ->
    @children.push view

  remove: (view) ->
    @children = _.without @children, view

  getChildren: -> @children

Ti.UI.createView = (attributes) ->
  new TitaniumView attributes

_.extend TitaniumView::, Backbone.Events
