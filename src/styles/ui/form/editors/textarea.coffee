colors = require('styles/theme').colors
helpers = require 'styles/helpers'

module.exports =

  view:
    helpers.deviceStyles
      ios:
        height: 75
        borderColor: colors.table.border
        borderRadius: 11
        backgroundColor: '#fff'
        bottom: 11
      android:
        height: Ti.UI.SIZE
        top: 0

  textarea:
    helpers.deviceStyles
      default:
        bottom: 11
        font:
          fontSize: 14
      ios:
        left: 7
        right: 7
      android:
        left: 0
        right: 0
        height: 75
