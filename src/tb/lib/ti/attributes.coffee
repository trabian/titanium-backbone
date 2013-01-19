matchers = require './helpers/matchers'

module.exports = ($) ->

  attr: (name, value) ->

    if _.isString name

      name = '_class' if name is 'class'

      if value is null
        @each ->
          delete @[name]

      # "name", "value" (Setter)
      else if value?
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

  removeAttr: (name) ->
    @attr name, null

  # Supports single or space-separated class names
  addClass: (newNames) ->

    $el = $(@)

    existingClass = $el.attr 'class'
    classList = []

    for newName in newNames.split /\s+/g when ! $el.hasClass newName
      classList.push newName

    classList = classList.join ' '

    newClass = if existingClass then "#{existingClass} #{classList}" else classList

    @attr 'class', newClass

  removeClass: (classNames) ->

    unless classNames
      return @attr 'class', ''

    if classList = @attr 'class'

      for className in classNames.split /\s+/g
        classList = classList.replace(matchers.classRE(className), " ")

      @attr 'class', classList.trim()

    else
      @

  hasClass: (className) ->
    _.some @, (el) -> matchers.hasClass el, className

  text: (text) ->

    getKey = (el) ->

      key = switch el._viewName
        when 'Button'
          'title'
        else
          'text'

    if text?

      @each ->

        key = getKey @

        if text is null
          delete @[key]
        else if text?
          @[key] = text

    else

      if el = @[0]
        return el[getKey el]

  val: (value) ->

    if value?
      @each -> @setValue value
    else
      @[0]?.getValue()
