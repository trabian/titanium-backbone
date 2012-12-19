_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

# Private: Flatten a nested source object into a flat hash of key-value
# delimited pairs.
#
# source - Nested Object to be flattened
# destination - Reference to the destination Object. Initialized on the
#   first call and passed to recursive calls to eliminate need to create
#   and merge new objects.
# parent - Reference to the current node's parent. Initialized on the
#   first call and passed to recursive calls to build the key for the
#   child node.
#
# Returns the flattened Object
flatten = (source, destination = {}, parent = null) ->

  for childKey, children of source

    key =  if parent? then [parent, childKey].join('.') else childKey

    if _.isString(children)
      destination[key] = children
    else
      flatten children, destination, key

  destination

module.exports =

  load: (modules) ->

    keys = flatten modules

    # Public: Shortcut for 'translate'
    t: (key, locals) -> @translate key, locals

    # Public: Translate a previously-defined i18n string given the
    # provided key.
    #
    # key - The String key to access. Usually something like
    #   'demo.main.helloWorld'
    # locals - An Object to be passed as the context to _.template if
    #   the referenced string contains variables to be interpolated.
    #
    # Examples
    #
    #   # Given the following previously-loaded i18n structure:
    #   #
    #   #   main:
    #   #     hello:
    #   #       world: 'Hello World!'
    #   #       you: 'Hello {{name}}!'
    #   #
    #
    #   translate 'main.hello.world'
    #   # => 'Hello World!'
    #
    #   translate 'main.hello.you', { name: 'Matt' }
    #   # => 'Hello Matt!'
    #
    # Returns the translated String.
    translate: (key, locals) ->

      if value = keys[key]
        if locals then (_.template value, locals) else value
      else
        "[key #{key} not found]"

    # Public: Determine whether the key has been loaded.
    #
    # key - The String key to check for presence.
    hasKey: (key) => keys[key]?
