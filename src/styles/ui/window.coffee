colors = require('styles/theme').colors

layout = (padding) ->
  top: padding
  left: padding
  right: padding
  layout: 'vertical'
  height: Ti.UI.SIZE

module.exports =

  view:
    backgroundColor: colors.window.background
    barColor: colors.bar
    tintColor: '#900'
    navTintColor: '#900'
    translucent: true

  layouts:

    default: layout 0

    noPadding: layout 0

    padded: layout

    fill:
      height: Ti.UI.FILL
      width: Ti.UI.FILL
      layout: 'vertical'
