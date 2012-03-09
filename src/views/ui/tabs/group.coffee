styles = require('styles').ui

ViewList = require 'presenters/view_list'

View = require 'views/base'

Tab = require './tab'

module.exports = class TabGroup extends View

  viewName: 'TabGroup'

  initialize: ->

    @bindTo @tabs, 'reset', @render

  buildTabs: (tabs) =>

    @tabs = new ViewList tabs

  render: =>

    @tabs.each (tab) =>

      tabView = new Tab
        presenter: tab
        model: @model

      @view.addTab tabView.render().view

    @

  open: => @view.open()

  close: => @view.close()
