label = (fontSize, options = {}) ->

  options.font = _.extend {}, options.font or {},
    fontSize: fontSize

  _.extend {}, options,
    height: 'auto'
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
