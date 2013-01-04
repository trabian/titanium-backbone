module.exports = ($) ->

  attr: (name, value) ->

    if _.isString name
      if value?
        @each -> @[name] = value
      else
        return @[0][name]

    else if _.isObject name
      @each -> @applyProperties name

    @
