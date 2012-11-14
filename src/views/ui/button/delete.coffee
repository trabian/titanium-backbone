styles = require('styles').ui

Button = require './index'

module.exports = class DeleteButton extends Button

  attributes: styles.button.delete

  initialize: ->

    @options.deleteButton ?= @options.text

    super

  click: =>

    if @options.confirmText

      dialog = Ti.UI.createOptionDialog
        title: @options.confirmText
        options: [@options.deleteButton, 'Cancel']
        destructive: 0
        cancel: 1

      dialog.addEventListener 'click', (e) =>

        if e.index is 0
          @options.click()

        return

      dialog.show()

    else
      @options.click()