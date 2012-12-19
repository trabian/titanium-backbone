styles = require('styles').ui.form.editors.string

View = require 'views/base'

module.exports = class StringEditor extends View

  viewName: 'TextField'

  attributes: =>

    viewStyles = if @presenter.inGroup()
      styles.inline.view
    else
      styles.standalone.view

    _.extend {}, viewStyles, @options.fieldStyle or {}

  events:
    change: 'change'

  initialize: ->

    @view.value = @presenter.get 'value'

    @view.hintText = if @presenter.inGroup()
      @presenter.hint()
    else
      @presenter.get 'label'

    @listen 'return'

    @initReturnKey()

    super

  change: =>

    @presenter.set
      value: @view.value

  save: =>
    @presenter.trigger 'save'

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
