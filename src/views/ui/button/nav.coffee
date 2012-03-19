styles = require('styles').ui

Button = require './index'

module.exports = class NavButton extends Button

  viewName: 'Button'

  attributes: styles.button.nav

  render: =>

    @view.title = @options.text

    @
