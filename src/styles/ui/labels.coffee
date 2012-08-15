label = (fontSize, options = {}) ->

  options.font = _.extend {}, options.font or {},
    fontSize: fontSize

  _.extend {}, options,
    height: Ti.UI.SIZE
    width: Ti.UI.FILL
    color: '#333'
    bottom: options.font.fontSize * 0.5 # Similar to bottom margin of 0.5em

heading = (fontSize) ->
  label fontSize,
    font:
      fontWeight: 'bold'

module.exports =

  h1: heading 20

  h2: heading 18

  h3: heading 16

  h4: heading 14

  h5: heading 12

  h6: heading 10

  p: label 14

  combined:

    view:
      height: Ti.UI.SIZE
      layout: 'vertical'

    primary:
      top: 0
      height: Ti.UI.SIZE
      width: Ti.UI.FILL
      color: '#333'
      font:
        fontSize: 15

    meta:
      bottom: 0
      height: Ti.UI.SIZE
      width: Ti.UI.FILL
      color: '#999'
      font:
        fontSize: 11
