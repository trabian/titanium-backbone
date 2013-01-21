###
 Partially extracted from https://github.com/padolsey/mini/blob/master/mini.js
 "mini" Selector Engine
 Copyright (c) 2009 James Padolsey
 -------------------------------------------------------
 Dual licensed under the MIT and GPL licenses.
    - http://www.opensource.org/licenses/mit-license.php
    - http://www.gnu.org/copyleft/gpl.html
 -------------------------------------------------------
 Version: 0.01 (BETA)
###

exprClassName = /^(?:[\w\-_]+)?\.([\w\-_]+)/
exprId = /^(?:[\w\-_]+)?#([\w\-_]+)/
exprNodeName = /^([\w\*\-_]+)/

exprAttributes = ///
  ^(?:[\w\-_]+)? # Allow preceding tagName
  \[(.*)\] # Match any expression in brackets
///

exprAttributePresence = ///
  ^(\w*)$
///

exprAttributeComponents = ///
  ^(\w*) # attribute name
  ([!^*$~|]?\=) # Find comparator with optional !, ^, or *
  [\"\'](\w*)[\"\'] # expected value (surrounded by quotes)
///

classCache = {}

classRE = (name) ->
  classCache[name] ?= new RegExp "(^|\\s)#{name}(\\s|$)"

hasClass = (el, className) ->
  classRE(className).test el._class

hasAttributes = (el, attributes) ->

  if exprAttributePresence.test attributes
    return _.has el, attributes

  if match = attributes.match exprAttributeComponents

    [ original, attr, comparison, value ] = match

    return switch comparison
      when '='
        el[attr] is value
      when '!='
        el[attr] isnt value
      when '^='
        (new RegExp("^#{value}")).test el[attr]
      when '$='
        (new RegExp("#{value}$")).test el[attr]
      when '*='
        (new RegExp(value)).test el[attr]
      when '~='
        (new RegExp("\\b#{value}\\b")).test el[attr]
      when '|='
        (new RegExp("^#{value}(-|$)")).test el[attr]
      else
        false

  false

hasNameClassAttrs = (el, nodeName, className, attributes) ->
  matches = !nodeName or (nodeName is '*') or el._viewName is nodeName
  matches = matches and (!className or hasClass el, className)
  matches and (!attributes or hasAttributes el, attributes)

# Parses a selector into its id, className, and nodeName components
parseSelector = (selector) ->

  id = selector.match(exprId)?[1]
  className = !id and selector.match(exprClassName)?[1]
  nodeName = !id and selector.match(exprNodeName)?[1]
  attributes = !id and selector.match(exprAttributes)?[1]

  { id, className, nodeName, attributes }

isIdNameClass = (el, id, nodeName, className, attributes) ->

  matches = (!id) or el.id is id
  matches and hasNameClassAttrs el, nodeName, className, attributes

# Use parsed selector as a single argument
isParsedSelector = (el, selectorParts) ->

  { id, nodeName, className, attributes } = selectorParts

  matches = (!id) or el.id is id
  matches and hasNameClassAttrs el, nodeName, className, attributes

matches = (el, selector) ->
  isParsedSelector el, parseSelector selector

module.exports = {
  classRE
  hasClass
  hasNameClassAttrs
  isIdNameClass
  isParsedSelector
  parseSelector
  matches
}
