styles = require('styles').ui.table.details

Row = require '../row'

Label = require 'views/ui/label'

module.exports = class DetailTableRow extends Row

  attributes: =>
    hasChild: @model.get('click')?

  events: =>
    'click': @model.get 'click'

  initialize: ->

    @bindTo @model, "change", =>
      @render()

  render: =>

    @wrap (view) =>

      view.add @title = @renderLabel 'title'

      if @model.get 'subtitle'
        view.add @renderLabel 'subtitle'
      else
        @title.width = '100%'

    @

  renderLabel: (name) =>

    label = new Label
      label: @model.get name
      style: styles.row[name].view
      labelStyle: styles.row[name].label
      controller: @controller

    label.render().view
