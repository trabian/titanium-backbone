# Matches HTML-style tags, e.g. <View>, <View/>, <View />, and <iPhone::NavigationGroup>
SIMPLE_TAG = /// ^<
  ([\w\:]*) # Letters and colons
  \s? # Optional space before closing />
  /? # Optional / before closing >
>$ ///

NESTED_TAG_OR_VALID_XML = ///
  <(.*)> # Has one tag
  (\s*) # May have empty space
  < # Includes another tag
  | # or
  / # Already includes a trailing slash
///

module.exports = (ti) ->

  buildView: ($, node) ->

    children = node.childNodes

    for index in [0...children.length]

      child = children.item index

      if child.nodeType is child.TEXT_NODE

        child.nodeValue

      else

        attributes = child.attributes

        attrHash = {}

        for attrIndex in [0...attributes.length]

          attr = attributes.item attrIndex

          attrName = attr.name

          if attrName is 'class'
            attrName = '_class'

          attrHash[attrName] = attr.value

        view = ti.createView child.nodeName, attrHash

        for nestedView in @buildView $, child

          if _.isString nestedView
            $(view).text nestedView
          else
            $(view).append nestedView

        view

  buildFromXml: ($, xml) ->

    if match = xml.match SIMPLE_TAG

      # Skip the XML parsing in the simple case
      $ ti.createView match[1]

    else

      # Convert `<View height='20'>` shorthand to proper XML, i.e. `<View height='20' />`
      unless NESTED_TAG_OR_VALID_XML.test xml
        xml = xml.replace /\>$/, " />"

      doc = Ti.XML.parseString "<root xmlns:iPhone='tb.iPhone' xmlns:iOS='tb.iOS' xmlns:iPad='tb.iOS'>#{xml}</root>"

      $ @buildView $, doc

      # $ elements
