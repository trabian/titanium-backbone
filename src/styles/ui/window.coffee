colors = require('styles/theme').colors

layout = (padding) ->
  top: padding
  left: padding
  right: padding
  layout: 'vertical'
  height: 'auto'

module.exports =

  view:
    backgroundColor: colors.window.background

  layouts:

    default: layout 11

    noPadding: layout 0

    padded: layout
