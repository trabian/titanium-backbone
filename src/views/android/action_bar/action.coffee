viewStyles = require('styles/ui/android').actionBar.action

BaseView = require 'views/base'

module.exports = class ActionView extends BaseView

  attributes: viewStyles.view

  events: { 'click' }

  click: =>
    @model.get('click')?() if @model.get 'enabled'

  initialize: ->

    super

    @bindToAndTrigger @model, 'change:enabled', =>
      @view.opacity = if @model.get('enabled') then 1 else 0.5

    @modelBind 'change:text change:icon', @render

  render: =>

    if icon = @model.get 'icon'

      @view.add @iconView = @make 'ImageView', viewStyles.icon,
        image: icon

    else
      @view.remove @iconView if @iconView
      @iconView = null

    if text = @model.get 'text'

      @view.add @labelView = @make 'Label', viewStyles.label, { text }

    else
      @view.remove @labelView if @labelView
      @labelView = null

    @

  dispose: ->

    @labelView = null
    @iconView = null

    super
