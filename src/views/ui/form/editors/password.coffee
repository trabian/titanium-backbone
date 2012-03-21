StringEditor = require './string'

module.exports = class PasswordEditor extends StringEditor

  attributes: ->
    _.extend {}, super,
      passwordMask: true
