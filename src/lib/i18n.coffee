_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

# Would rather it not be recursive, but this will do.
flatten = (source, destination = {}, parent = null) ->

  for childKey, children of source

    key = if parent? then "#{parent}.#{childKey}" else childKey

    if _.isString(children)
      destination[key] = children
    else
      flatten children, destination, key

  destination

module.exports =

  load: (modules) ->

    keys = flatten modules

    translate = (key, locals) =>

      if value = keys[key]
        if locals then (_.template value, locals) else value
      else
        "[key #{key} not found]"

    t: translate
    translate: translate
    hasKey: (key) => keys[key]?

