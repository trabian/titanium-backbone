matchers = require './matchers'

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

snack = /(?:[\w\-\\.#]+)+(?:\[\w+?=([\'"])?(?:\\\1|.)+?\1\])?|\*|>/ig

findOne = (context, test) ->

  return unless context

  if _.isArray context

    if result = _.find(context, (el) -> findOne el, test)
      result

  else
    if test context
      context
    else
      findOne context.children, test

# This is likely not very efficient
findAll = (context, test, collector = [], include = true) ->

  return [] unless context

  if _.isArray context
    _.each context, (el) -> findAll el, test, collector
  else
    collector.push context if include and test(context)
    findAll context.children, test, collector

  collector

findById = (id, context) ->
  findOne context, (el) -> el.id is id

findByNodeAndClassName = (nodeName, className, context, include = true) ->
  findAll context, ((el) -> matchers.hasNameClassAttrs el, nodeName, className), [], include

filterParents = (selectorParts, collection, direct) ->

  parentSelector = selectorParts.pop()

  if parentSelector is '>'
    return filterParents selectorParts, collection, true

  ret = []

  { id, className, nodeName } = matchers.parseSelector parentSelector

  for node in collection

    parent = node.parent

    while parent

      matches = matchers.isIdNameClass parent, id, nodeName, className

      break if direct or matches

      parent = parent.parent

    if matches
      ret.push node

  if selectorParts[0] and ret[0] then filterParents(selectorParts, ret) else ret

_is = (selector, context) ->

  parts = selector.match snack
  part = parts.pop()

  if matchers.matches context, part

    if parts[0]
      filterParents(parts, [context]).length > 0
    else
      true

find = (selector = '*', context, includeSelf = false) ->

  parts = selector.match snack
  part = parts.pop()

  if selector.indexOf(',') > -1
    ret = []
    for selector in selector.split(/,/g)
      ret = _.uniq ret.concat find selector.trim(), context
    return ret

  { id, className, nodeName } = matchers.parseSelector part

  if id
    return if child = findById(id, context) then [child] else []
  else
    collection = findByNodeAndClassName nodeName, className, context, includeSelf

  if parts[0] and collection[0] then filterParents(parts, collection) else collection

module.exports =
  find: find
  is: _is
