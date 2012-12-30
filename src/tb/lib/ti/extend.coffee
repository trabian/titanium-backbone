ElementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

module.exports = (ti) ->

  $ = (element) ->
    if element instanceof ElementCollection
      element
    else if _.isString element

      # Matches HTML-style tags, e.g. <View>, <View/>, <View />, and <iPhone::NavigationGroup>
      TAG = /// ^<
        ([\w\:]*) # Letters and colons
        \s? # Optional space before closing />
        /? # Optional / before closing >
      >$ ///

      if match = element.match TAG
        $ ti.createView match[1]

    else
      ElementCollection if _.isArray element then element else [element]

  events = require('./events') $
  manipulation = require('./manipulation') $
  traversal = require('./traversal') $
  attributes = require('./attributes') $

  fn = _({}).extend events, manipulation, traversal, attributes

  ElementCollection:: = fn

  $
