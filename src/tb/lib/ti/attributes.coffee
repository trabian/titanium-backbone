module.exports = ($) ->

  attr: (name, value) ->

    if _.isString name

      name = '_class' if name is 'class'

      # "name", "value" (Setter)
      if value?
        @each ->
          @[name] = value

      # "name" (Getter)
      else
        return @[0][name]

    else if _.isObject name

      properties = name

      if _.has properties, 'class'
        properties._class = properties.class
        delete properties.class

      # name: value
      @each ->
        @applyProperties properties

    @
