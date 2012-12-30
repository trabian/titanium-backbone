module.exports = ($) ->

  attr: (name, value) ->

    if _.isString name
      if value?
        @[0][name] = value
      else
        return @[0][name]

    else if _.isObject name
      @[0].applyProperties name

    @
