colors = require('styles/theme').colors
labels = require 'styles/ui/labels'

padding =
  top: 11
  right: 11
  bottom: 11
  left: 11

module.exports =

  view:
    height: Ti.UI.SIZE
    borderWidth: '1px'
    borderColor: colors.border.default
    backgroundColor: '#fff'
    top: 11
  html:
    _({}).extend padding,
      height: Ti.UI.SIZE
  text:
    _({}).extend labels.p, padding
