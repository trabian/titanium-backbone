viewStyles = require('styles/ui/android').actionBar.action

BaseView = require 'views/base'

module.exports = class ActionView extends BaseView

  attributes: viewStyles.view

  events: { 'click' }

  click: =>
    @model.get('click')?() unless @model.get 'disabled'

  initialize: ->

    super

    @bindToAndTrigger @model, 'change:disabled', =>

      if @model.get 'disabled'
        @view.opacity = 0.5
      else
        @view.opacity = 1

    @modelBind 'change:title change:icon', @render

  render: =>

    if icon = @model.get 'icon'

      @view.add @iconView = @make 'ImageView', viewStyles.icon,
        image: icon

    else
      @view.remove @iconView if @iconView
      @iconView = null

    if label = @model.get 'label'

      @view.add @labelView = @make 'Label', viewStyles.label,
        text: label

    else
      @view.remove @labelView if @labelView
      @labelView = null

    @

  dispose: ->

    @labelView = null
    @iconView = null

    super
