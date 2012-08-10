colors = require('styles/theme').colors

module.exports =

  inline:
    view:
      width: Ti.UI.FILL
      color: colors.form.value
  standalone:
    view:
      height: 44
      width: Ti.UI.FILL
      bottom: 11
      color: colors.form.value
      borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
      textAlign: 'left'
      font:
        fontSize: 20
