elementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

events = require './events'

fn = _({}).extend events,

  each: (callback) -> _.each @, callback

elementCollection:: = fn

module.exports = (element) -> elementCollection [element]
