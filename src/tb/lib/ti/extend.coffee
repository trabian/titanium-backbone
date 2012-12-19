elementCollection = (collection) ->
  collection = collection || []
  collection.__proto__ = arguments.callee.prototype
  collection

events = require './events'

fn = _({}).extend events,

  each: (callback) -> _.each @, callback

elementCollection:: = fn

module.exports = (element) -> elementCollection [element]

  # return dom

  # out = new Z(element)

  # console.warn out.unbind?

  # out

  # collection = [ element ]

  # _.extend collection, fn

  # collection

# module.exports = class Wrapper

#   constructor: (element) ->

#     @collection = [ element ]

#     @[] = (index) ->
#       @collection[index]
