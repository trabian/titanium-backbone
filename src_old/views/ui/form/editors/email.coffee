StringEditor = require './string'

module.exports = class EmailEditor extends StringEditor

  attributes: ->
    _.extend {}, super,
      keyboardType: Ti.UI.KEYBOARD_EMAIL
