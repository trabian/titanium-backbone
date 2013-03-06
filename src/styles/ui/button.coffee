colors = require('styles/theme').colors

helpers = require 'styles/helpers'

module.exports =

  default:
    helpers.deviceStyles
      default:
        height: 44
        width: Ti.UI.FILL
        left: 0
        right: 0
        backgroundImage: '/images/core/buttons/default.png'
        backgroundSelectedImage: '/images/core/buttons/default_active.png'
      android:
        color: '#fff'
        font:
          fontSize: 14
          fontWeight: 'bold'

  delete:
    helpers.deviceStyles
      default:
        height: 44
        width: Ti.UI.FILL
        left: 0
        right: 0
        backgroundImage: '/images/core/buttons/delete.png'
        backgroundSelectedImage: '/images/core/buttons/delete_active.png'
      android:
        color: '#fff'
        font:
          fontSize: 14
          fontWeight: 'bold'

  nav: null
