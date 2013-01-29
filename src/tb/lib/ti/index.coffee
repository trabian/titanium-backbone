values = require './helpers/values'

ti =

  # Public: Create a Titanium View given a viewName.
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
  createView: (viewNameOrCreator, attributeHashes...) ->

    attributes = _.extend {}, attributeHashes...

    viewCreator = if _.isString viewNameOrCreator

      attributes._viewName = viewName = viewNameOrCreator

      # Extract module name
      if match = viewName.match(/(.*):(.*)/)
        module = match[1]
        viewName = match[2]

      if viewName is 'div'
        attributes._viewName = viewName = 'View'

      creator = "create#{viewName}"

      if module then Ti.UI[module][creator] else Ti.UI[creator]

    else

      viewNameOrCreator

    # Equivalent to, for example, Ti.UI.createLabel attributes
    if viewCreator
      viewCreator values.convertTi attributes
    else
      console.log "Could not find viewCreator for #{viewNameOrCreator}"

  $: (element) -> extend element

extend = require('./extend') ti

module.exports =

  createView: ti.createView
  $: extend
  Ti: Ti

