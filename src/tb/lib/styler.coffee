mini = require 'tb/lib/ti/helpers/mini'

# matcher = require 'tb/lib/ti/helpers/matchers'
mergeAttributes = (el, attributes, newAttributes, priority) ->

  for key, value of newAttributes

    if _.isObject(value) and value.important
      priority += 1000
      value = value.value

    if existing = attributes[key]

      if priority >= existing.priority
        existing.value = value
        existing.priority = priority

    else

      hasInlineAttribute = _.include el._inlineAttributes, key

      unless hasInlineAttribute and priority <= 100
        attributes[key] = { value, priority }

module.exports =

  load: (@styles) ->

  reset: -> @styles = null

  shallowStyles: (viewName) ->
    @styles?[viewName]?.rules or {}

  stylesForView: (el) ->

    attributes = {}

    if viewStyles = @styles?[el._viewName]

      if viewStyles.rules

        mergeAttributes el, attributes, viewStyles.rules, 0

      if selectors = viewStyles.selectors

        for selectorRules in selectors

          { rules, selector } = selectorRules

          if mini.is selector, el
            mergeAttributes el, attributes, rules, selector.split(/\s/).length

      _.reduce attributes, (out, val, key) ->
        out[key] = val.value
        out
      , {}
