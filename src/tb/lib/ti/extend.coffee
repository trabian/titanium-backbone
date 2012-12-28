elementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

$ = (element) -> elementCollection [element]

events = require('./events') $
manipulation = require('./manipulation') $
traversal = require('./traversal') $

fn = _({}).extend events, manipulation, traversal

elementCollection:: = fn

module.exports = $
