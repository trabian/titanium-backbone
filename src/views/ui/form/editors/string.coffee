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
  initReturnKey: =>

    @defaultReturnKey = @view.returnKeyType

    @modelBind 'change:lastInvalid', =>

      if @presenter.get 'lastInvalid'
        @view.enableReturnKey = true
        @view.returnKeyType = Ti.UI.RETURNKEY_DONE
        @on 'return', @save
      else
        @view.enableReturnKey = true
        @view.returnKeyType = @defaultReturnKey
        @off 'return', @save
