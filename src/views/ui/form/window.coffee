styles = require('styles').ui.form.window

{ Window } = require 'views/ui'

NavButton = require 'views/ui/button/nav'
FormView = require 'views/ui/form'

module.exports = class FormWindow extends Window

  initialize: ->

    @options.saveButton ?= 'Save'

    @view.leftNavButton = @renderCloseButton()
    @view.rightNavButton = @renderSaveButton()
    super

  render: =>

    @layout (view) =>

      @prepend? view

      formView = new FormView
        controller: @controller
        presenter: @presenter
        fieldStyles: @options.fieldStyles

      view.add formView.render().view

      @append? view

    @

  renderCloseButton: =>

    button = new NavButton
      text: 'Cancel'
      click: @close

    button.render().view

  renderSaveButton: =>

    button = new NavButton
      click: @save
      text: @options.saveButton
      style: styles.button

    @bindToAndTrigger @presenter, 'change:saveable', =>
      button.view.enabled = @presenter.get 'saveable'

    button.render().view

  save: =>
    @presenter.save()
