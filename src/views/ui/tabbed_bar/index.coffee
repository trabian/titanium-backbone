styles = require('styles').ui.tabbedBar

CollectionView = require 'views/base/collection'

TabbedBarLabel = require './label'

ViewPresenter = require 'presenters/view'

# Platform Independent Tabbed Bar
#
# Creates a bar of buttons that maintains a 
# selected state
#
# Takes akes an array of labels on view creation,
# but will also take an object that has an icon, like:
# new TabbedBar
#   labels: [ 'First', {title :'Second', icon: '/images/second.png'} ]
#   index: 0

module.exports = class TabbedBar extends CollectionView

  attributes: styles.view

  addAll: =>

    @view.add @wrapper = @make 'View', styles.wrapper

    @width = (100 / @collection.length) - 0.3

    super

  addOne: (presenter, index) =>

    @wrapper.add (new TabbedBarLabel
      presenter: presenter
      controller: @controller
      style:
        width: "#{@width}%"
    ).render().view

    if index
      @wrapper.add @make 'View', styles.divider
