class TitaniumView

  tiClassName: 'TiUIView'

  bubbleParent: true

  constructor: (attributes) ->
    for name, value of attributes
      @[name] = value
    @children = []
    @hidden = false

  applyProperties: (properties) ->
    for key, value of properties
      @[key] = value

  addEventListener: (name, event) ->
    @on name, event

  removeEventListener: (name, event) ->
    @off name, event

  fireEvent: (name, event) ->

    event = _({}).extend { source: @ }, event or {}

    @trigger name, event

    if @bubbleParent
      @parent?.fireEvent name, event

  add: (view) ->
    view.parent = @
    @children.push view

  remove: (view) ->
    @children = _.without @children, view

  getChildren: -> @children

  getParent: -> @parent

  hide: -> @hidden = true

  show: -> @hidden = false

  toString: ->
    "[object #{@tiClassName}]"

Ti.UI.createView = (attributes) ->
  new TitaniumView attributes

_.extend TitaniumView::, Backbone.Events
