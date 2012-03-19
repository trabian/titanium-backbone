styles = require('styles').ui

View = require 'views/base'

module.exports = class Button extends View

  viewName: 'ButtonBar'

  events: =>
    click: @options.click

  attributes: styles.button.default

  render: =>

    @view.labels = [@options.text]

    @
