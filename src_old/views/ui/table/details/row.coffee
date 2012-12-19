styles = require('styles').ui.table.details

Row = require '../row'

Label = require 'views/ui/label'

module.exports = class DetailTableRow extends Row

  attributes: =>
    _.extend {}, styles.row.view,
      hasChild: @model.get('click')?

  events: =>
    'click': @model.get 'click'

  initialize: ->

    @modelBind "change", =>
      @render()

    super

  render: =>

    @wrap (view) =>

      @add (@title = @buildLabel 'title'), view

      if @model.get 'subtitle'
        @add (@buildLabel 'subtitle'), view
      else
        @title.view.width = '100%'

    @

  buildLabel: (name) =>

    new Label
      label: @model.get name
      style: styles.row[name].view
      labelStyle: styles.row[name].label
      controller: @controller
