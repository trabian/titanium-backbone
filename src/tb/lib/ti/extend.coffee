elementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

$ = (element) -> elementCollection [element]

events = require('./events') $
traversal = require('./traversal') $

fn = _({}).extend events, traversal

elementCollection:: = fn

module.exports = $
