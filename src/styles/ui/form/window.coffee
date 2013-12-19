{ deviceStyles } = require 'styles/helpers'

module.exports =

  button:
    style: Ti.UI.iPhone.SystemButtonStyle.DONE
  submitButton:
    deviceStyles
      ios7:
        top: 22
        bottom: 11

