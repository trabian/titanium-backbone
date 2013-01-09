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

classCache = {}

classRE = (name) ->
  classCache[name] ?= new RegExp "(^|\\s)#{name}(\\s|$)"

hasClass = (el, className) ->
  classRE(className).test el._class

hasNodeNameAndOrClass = (el, nodeName, className) ->
  matches = !nodeName or el._viewName is nodeName
  matches and (!className or hasClass el, className)

# Parses a selector into its id, className, and nodeName components
parseSelector = (selector) ->

  id = selector.match(exprId)?[1]
  className = !id and selector.match(exprClassName)?[1]
  nodeName = !id and selector.match(exprNodeName)?[1]

  { id, className, nodeName }

isIdNameClass = (el, id, nodeName, className) ->

  matches = (!id) or el.id is id
  matches and hasNodeNameAndOrClass el, nodeName, className

# Use parsed selector as a single argument
isParsedSelector = (el, selectorParts) ->

  { id, nodeName, className } = selectorParts

  matches = (!id) or el.id is id
  matches and hasNodeNameAndOrClass el, nodeName, className

module.exports = {
  classRE
  hasClass
  hasNodeNameAndOrClass
  isIdNameClass
  isParsedSelector
  parseSelector
}
