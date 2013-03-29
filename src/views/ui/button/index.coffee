styles = require('styles').ui

Presenter = require 'presenters/view'

View = require 'views/base'

environment = require 'environment'

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

    if environment.android
      if @presenter.get 'enabled'
        @view.opacity = 1.0
      else
        @view.opacity = 0.5

    @

  click: =>
    @options.click()
