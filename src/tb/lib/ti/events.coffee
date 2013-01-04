# This event-handling code is pulled from Zepto but has been modified to
# remove DOM-specific fuctionality.
#
# Original source: https://github.com/madrobby/zepto/blob/master/src/event.js
handlers = {}

myId = (element) ->
  element._eventId ?= _.uniqueId 'event_element_'

matcherFor = (ns) ->
  new RegExp('(?:^| )' + ns.replace(' ', ' .* ?') + '(?: |$)')

parse = (event) ->

  parts = String(event).split '.'

  e: parts[0]
  ns: parts.slice(1).sort().join ' '

findHandlers = (element, event, fn) ->

  event = parse event

  if event.ns
    matcher = matcherFor event.ns

  _.filter (handlers[myId(element)] || []), (handler) ->

    handler and
      ((not event.e) or handler.e is event.e) and
      ((not event.ns) or matcher.test handler.ns) and
      ((not fn) or myId(handler.fn) is myId(fn))

add = (element, event, fn) ->

  id = myId element

  set = handlers[id] ?= []

  handler = parse event

  handler.fn = fn

  handler.proxy = (e) ->

    e ?= {}

    callback.apply element, [e].concat e.data

    return

  handler.index = set.length

  set.push handler

  element.addEventListener handler.e, handler.proxy

remove = (element, event, fn) ->

  id = myId element

  for handler in findHandlers element, event, fn
    delete handlers[id][handler.index]
    element.removeEventListener handler.e, handler.proxy

module.exports = ($) ->

  bind: (event, callback) ->
    @each (element) -> add element, event, callback

  on: (event, callback) ->
    @bind event, callback

  unbind: (event, callback) ->
    @each (element) -> remove element, event, callback

  off: (event, callback) ->
    @unbind event, callback

  trigger: (event, data) ->
    @each (element) -> element.fireEvent event, { data }

  triggerHandler: (event, data) ->

    @each (element) ->
      handler.proxy(data) for handler in findHandlers element, event

