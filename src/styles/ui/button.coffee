{ colors, fonts } = require 'styles/theme'

buttonStyles =
  height: 33
  width: Ti.UI.FILL
  left: "-2px"
  right: "-2px"
  backgroundColor: "#fff"
  borderColor: colors.table.border
  borderWidth: "1px"
  font:
    fontFamily: fonts.base

module.exports =

  default: buttonStyles

  delete: _({}).extend buttonStyles, {}

  nav: null
