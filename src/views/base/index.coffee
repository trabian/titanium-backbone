util = require 'lib/util'

# Internal: Create a Titanium View given a viewName.
#
# viewName - The String naming the Titanium view to be created.
#     If the viewName matches [module]::[name] then the Titanium view will be
#     a child of Ti.UI.[module] instead of Ti.UI.
#
# attributes - The parameters to be passed to the view creator
#
# Examples
#
#   createTitaniumView 'Label', { text: 'Example' }, { color: '#ccc' }
#   # Equivalent to: Ti.UI.createLabel { text: 'Example', color: '#ccc' }
#
#   createTitaniumView 'iPhone::NavigationGroup', window: sampleWindow
#   # Equivalent to: Ti.UI.iPhone.createNavigationGroup { window: sampleWindow }
#
# Returns the created view
createTitaniumView = (viewName, attributes) ->

  # Extract module name
  viewCreator = if match = viewName.match(/(.*)::(.*)/)
    module = match[1]
    viewName = match[2]

  creator = "create#{viewName}"

  viewCreator = if module
    Ti.UI[module][creator]
  else
    Ti.UI[creator]

  # Equivalent to, for example, Ti.UI.createLabel attributes
  viewCreator attributes

# Internal: The name of options to be attached directly to the view should they be
# incountered in the 'options' hash.
viewOptions = ['model', 'collection', 'view', 'id', 'attributes', 'className', 'viewName', 'presenter', 'controller']

# Public: The View class is very similar to Backbone.View but represents a Titanium view
# instead of a DOM element.
module.exports = class View

  _(View.prototype).extend Backbone.Events

  # Public: Default viewName. Override as needed.
  viewName: 'View'

  # Public: Initialize the view
  constructor: (options = {}) ->

    @cid = _.uniqueId 'view'

    @_configure options
    @_bindControllerEvents()
    @_ensureView()
    @initialize.apply @, arguments
    @delegateEvents()

  # Public: Provide public access to the internal getValue method
  getValue: (prop) => util.getValue @, prop

  # Public: Empty by default. Override it with your own initialization logic.
  initialize: ->

  # Internal: Creates @options and attaches keys with special meaning
  #   (as defined by 'viewOptions') directly to the view.
  #
  # Returns the configured @options hash
  _configure: (options) ->

    options = _.extend {}, @options, options if @options

    for attr in viewOptions
      if options[attr] then @[attr] = options[attr]

    @options = options

  _bindControllerEvents: ->
    @controller?.context?.on 'destroy', @destroy

  # Internal: Creates the view if it doesn't already exist.
  #
  # Returns the generated view
  _ensureView: ->

    unless @view

      attrs = @getValue('attributes') or {}

      if style = @options.style
        attrs = _.extend {}, attrs, style

      attrs.id = @id if @id
      attrs.className = @className if @className 

      @view = @make @viewName, attrs

  # Public: Create a Titanium View given a viewName.
  #
  # viewName - The String naming the Titanium view to be created.
  #
  # attributeHashes - One or more hashes to be merged to form the
  #     view attributes
  #
  # Examples
  #
  #   @make 'Label', { text: 'Example' }, { color: '#ccc' }
  #   # => Ti.UI.Label (text='Example', color='#ccc')
  #
  #   @make 'iPhone::NavigationGroup', window: sampleWindow
  #   # => Ti.UI.iPhone.NavigationGroup (window=sampleWindow)
  #
  # Returns the created view
  make: (viewName, attributeHashes...) ->

    attributes = _.extend {}, attributeHashes...

    for key, attribute of attributes
      attributes[key] = @parseTitaniumProperty attribute

    createTitaniumView viewName, attributes

  # Public: Empty by default. Override it with your own render logic.
  render: => @

  # Converts string properties to Titanium properties.
  #
  # property - The String to be converted to a Titanium property.
  #
  # Examples
  #
  #   @parseTitaniumProperty 'Ti.UI.iPhone.SystemButton.DISCLOSURE'
  #   # => Ti.UI.iPhone.SystemButton.DISCLSURE
  #
  # to the named Titanium variables (Ti.UI.iPhone.SystemButton.DISCLOSURE
  # in this case)
  parseTitaniumProperty: (property) ->

    if _.isString(property) and tiProperty = property.match /^Ti\.(.*)/
      property = tiProperty[1]?.split '.'
      _.reduce property, (hashPart, subKey) ->
        hashPart[subKey]
      , Ti
    else
      property

  delegateEvents: (events) ->

    unless events or events = @getValue 'events'
      return

    for name, method of events

      unless _.isFunction method
        method = @[method]

      if method

        @view.addEventListener name, =>

          method()

          # Returning a value from a Titanium event listener can cause problems,
          # so we don't by overriding CoffeeScripts default return.
          return

  listen: (name, callback) =>

    @view.addEventListener name, (e) ->

      @trigger name, e

      callback? e

      return

  bindTo: (model, eventName, callback) =>

    unless @bindings

      unless @controller?.context

        console.warn """ 
          This view (#{@viewName}) has not been provided with an associated context
          (usually the Window within which the view is displayed).  This means we
          won't be able to automatically destroy the view when the context is destroyed,
          and the events being bound will likely cause a memory leak.
        """

    @bindings or= []

    model.on eventName, callback, @

    @bindings.push { model, eventName, callback }

  bindToAndTrigger: (model, eventName, callback) =>
    @bindTo model, eventName, callback
    callback?()

  destroy: =>

    if @bindings
      for binding in @bindings
        do (binding) =>
          binding.model.off binding.eventName, binding.callback

  # Public: Titanium doesn't provide a method for completely clearing a view and
  # replacing it with a new view (similar to @$el.html('replace everything') which
  # is available via jQuery on the DOM). We mimic that functionality here by creating
  # a wrapper view which will be removed and readded on subsequent calls.
  #
  # This makes it much easier to call the 'render' method for a view multiple times.
  #
  # Example:
  #
  #   class NameView extends View
  #
  #     initialize: ->
  #       @bindTo @model, 'change:name', @render
  #
  #     @render: =>
  #
  #       @wrap (view) =>
  #
  #         view.add @make 'Label', labelStyles,
  #           text: @model.get 'name'
  #
  #       @
  #
  wrap: (callback) =>

    @view.remove @wrapper if @wrapper?

    @wrapper = @make 'View', @view.attributes
      #height: @view.height or 'auto'
      #layout: @view.layout

    callback @wrapper

    @view.add @wrapper
