styles = require('styles').ui

Presenter = require 'presenters/view'

View = require 'views/base'

module.exports = class Button extends View

  viewName: 'Button'

  attributes: styles.button.default

  events:
    click: 'click'

  initialize: ->

    @presenter ?= new Presenter
      enabled: @options.enabled ? true
      text: @options.text

    @modelBind 'change', @render

    super

  render: =>

    @view.setTitle @presenter.get 'text'
    @view.setEnabled !! @presenter.get 'enabled'

    @

  click: =>

    @options.click
      source: @view
