styles = require('styles').ui.form.editors.textarea

NavButton = require 'views/ui/button/nav'

View = require 'views/base'

module.exports = class TextareaEditor extends View

  attributes: styles.view

  render: =>

    @view.add @field = @make 'TextArea', styles.textarea,
      value: @presenter.get 'value'

    @field.addEventListener 'change', =>

      @presenter.set
        value: @field.value

      return

    @
