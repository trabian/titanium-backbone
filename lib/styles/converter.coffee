stylus = require 'stylus'

compiler = require 'stylus/lib/visitor/compiler'
matchers = require '../../src/tb/lib/ti/helpers/matchers'

compiler.prototype.visitGroup = (group) ->

  stack = this.stack
  stack.push group.nodes

  if group.block.hasProperties

    selectors = this.compileSelectors stack

    for selector in selectors

      [parents..., leaf] = selector.split ' '

      { nodeName, className, id } = matchers.parseSelector leaf

      leafNode = @styles[nodeName ? className ? id] ?= {}

      if parents.length or (nodeName and className)

        leafNode.selectors ?= []

        leafNode.selectors.push @context =
          selector: selector
          rules: {}

      else
        @context = leafNode

    this.buf += (this.selector = selectors.join(if this.compress then ',' else ',\n'))

  this.visit group.block

  stack.pop()

compiler.prototype.visitProperty = (prop) ->

  val = @visit(prop.expr).trim()
  name = prop.name

  if match = val.match /(.*)\!important/i

    val =
      important: true
      value: match[1].trim()

  if name is 'font'

    [ size, weight ] = val.split /\s/

    val = {}

    if size
      val.fontSize = size

    if weight
      val.fontWeight = weight

  @context.rules ?= {}

  @context.rules[name] = val

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
