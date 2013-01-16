libxmljs = require 'libxmljs'

class TitaniumXmlAttr

  constructor: (@name, @value) ->

class TitaniumNamedNodeMap

  constructor: (@node) ->
    @attrs = @node.attrs()
    @length = @attrs.length

  _buildAttr: (attr) ->
    new TitaniumXmlAttr attr.name(), attr.value()

  item: (index) ->
    @_buildAttr @attrs[index]

  getNamedItem: (name) ->
    @_buildAttr @node.attr(name)

class TitaniumNodeList

  constructor: (@node) ->
    @children = @node.childNodes()
    @length = @children.length

  item: (index) ->
    new TitaniumXmlNode @children[index]

class TitaniumXmlNode

  constructor: (@node) ->

    @TEXT_NODE = 3
    @ELEMENT_NODE = 1

    @nodeType = switch @node.type()
      when 'text'
        @TEXT_NODE
      when 'element'
        @ELEMENT_NODE

    if @nodeType is @TEXT_NODE

      @nodeValue = @node.text()

    else

      @nodeName = @node.name()

      if prefix = @node.namespace()?.prefix()
        @nodeName = [prefix, @nodeName].join ':'

      if @node.child(0)?.type() is 'text'
        @textContent = @node.child(0).text()

      @attributes = new TitaniumNamedNodeMap @node
      @childNodes = new TitaniumNodeList @node

class TitaniumXmlDocument

  constructor: (xml) ->

    xmlDoc = libxmljs.parseXml xml

    @childNodes = new TitaniumNodeList xmlDoc.root()

Ti.XML =

  parseString: (xml) ->

    new TitaniumXmlDocument (xml)
