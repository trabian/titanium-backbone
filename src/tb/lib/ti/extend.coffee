ElementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

module.exports = (ti) ->

  builder = require('./builder') ti

  $ = (element) ->

    if element instanceof ElementCollection
      element
    else if _.isString element
      builder.buildFromXml $, element

    else
      if element
        ElementCollection if _.isArray element then element else [element]
      else
        ElementCollection []

  $.Deferred = jQuery.Deferred
  $.Callbacks = jQuery.Callbacks

  ajax = require('./ajax') $
  events = require('./events') $
  manipulation = require('./manipulation') $
  traversal = require('./traversal') $
  attributes = require('./attributes') $

  fn = _({}).extend events, manipulation, traversal, attributes

  ElementCollection:: = fn

  $
