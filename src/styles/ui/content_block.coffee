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
    borderWidth: 1
    borderColor: colors.border.default
    borderRadius: 11
    backgroundColor: '#fff'
    top: 11
  html:
    _({}).extend padding,
      height: Ti.UI.SIZE
  text:
    _({}).extend labels.p, padding
