styles = require('styles').ui.tabbedBar.label

View = require 'views/base'

module.exports = class TabbedBarLabel extends View

  attributes: styles.inactive

  events: =>
    click: =>
      @presenter.collection.selectOne @presenter

  initialize: ->

    @modelBindAndTrigger 'change:selected', =>
      @updateState @presenter.get 'selected'

  updateState: (selected) =>

    gradientStyle = if selected then 'active' else 'inactive'

    @view.backgroundGradient = styles[gradientStyle].backgroundGradient

  render: =>

    if icon = @presenter.get 'icon'

      @view.add @make 'View', styles.icon,
        backgroundImage: icon

    @view.add @make 'Label', styles.text,
      text: @presenter.get 'label'
      left: 20 if icon

    @
