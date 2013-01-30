ElementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

global = this

module.exports = (ti) ->

  builder = require('./builder') ti

  $ = global.$ = (element) ->

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

  $.param = jQuery.param

  extensions = for name in ['ajax', 'events', 'manipulation', 'traversal', 'attributes']
    require "./#{name}"

  fn = _({}).extend extensions...

  ElementCollection:: = fn

  $
