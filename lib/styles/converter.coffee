stylus = require 'stylus'

compiler = require 'stylus/lib/visitor/compiler'
matchers = require '../../src/tb/lib/ti/helpers/matchers'
_ = require 'underscore'

addSelectorRules = (selector, rules, styles) ->

  [parents..., leaf] = selector.split ' '

  { nodeName, className, id } = matchers.parseSelector leaf

  leafNode = styles[nodeName ? className ? id] ?= {}

  if parents.length or (nodeName and className)

    if existingSelectors = leafNode.selectors

      existingRules = _.find existingSelectors, (existingSelector) ->
        existingSelector.selector is selector

      if existingRules
        existingRules.rules = _({}).extend existingRules.rules, rules

      else

        existingSelectors.push
          selector: selector
          rules: rules

    else
      leafNode.selectors = [ { selector, rules } ]

  else
    leafNode.rules = _({}).extend (leafNode.rules ? {}), rules

compiler.prototype.visitGroup = (group) ->

  @stack.push group.nodes

  @ruleStack ?= []
  selectors = []

  @ruleStack.push {}

  if group.block.hasProperties

    selectors = this.compileSelectors @stack

    this.buf += (this.selector = selectors.join(if this.compress then ',' else ',\n'))

  this.visit group.block

  rules = @ruleStack.pop()

  unless _.isEmpty rules

    for selector in selectors
      addSelectorRules selector, rules, @styles

  @stack.pop()

compiler.prototype.visitProperty = (prop) ->

  context = _.last this.ruleStack

  val = @visit(prop.expr).trim()
  important = false

  name = prop.name

  if match = val.match /(.*)\!important/i

    important = true
    val = match[1].trim()

  if name.match /^font/

    switch name
      when 'font'

        [ size, weight ] = val.split /\s/

        val = {}

        if size
          val.fontSize = size

        if weight
          val.fontWeight = weight

      when 'font-weight'

        val =
          fontWeight: val

      when 'font-size'

        val =
          fontSize: val

    name = 'font'

  context[name] = if important
    value: val
    important: true
  else
    val

module.exports =

  convertRenderer: (stylusWrapper, callback) ->

    output = undefined

    compiler.prototype.styles = {}

    stylusWrapper.render (err) ->
      output = compiler.prototype.styles
      callback? err, output

  convert: (input, callback) ->

    output = undefined

    compiler.prototype.styles = {}

    stylus.render input, (err) ->
      output = compiler.prototype.styles
      callback? err, output

    unless callback

      until output
        console.warn 'waiting...'

      output
