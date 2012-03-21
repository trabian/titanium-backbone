styles = require('styles').ui.form.editors.string

View = require 'views/base'

module.exports = class StringEditor extends View

  viewName: 'TextField'

  attributes: -> styles.view

  events:
    change: 'change'

  initialize: ->
    @view.value = @presenter.get 'value'
    @view.hintText = @presenter.hint()

  change: =>

    @presenter.set
      value: @view.value
