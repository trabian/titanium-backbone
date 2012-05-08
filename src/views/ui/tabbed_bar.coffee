styles = require('styles').ui.tabbedBar

View = require 'views/base'

ViewPresenter = require 'presenters/view'

# Platform Independent Tabbed Bar
#
# Creates a bar of buttons that maintains a 
# selected state
#
# Takes akes an array of labels on view creation,
# but will also take an object that has an icon, like:
# new TabbedBar
#  	labels: [ 'First', {title :'Second', icon: '/images/second.png'} ]
#		index: 0

module.exports = class TabbedBar extends View

	attributes: styles.view

	initialize: ->

		@presenter = new ViewPresenter
			currentIndex: @options.index

	render: =>
		wrapper = @make 'View', styles.wrapper

		@view.add wrapper

		count = @options.labels.length

		width = (100 / count) - 0.3

		index = 0

		for label in @options.labels

			unless index is 0
				wrapper.add @make 'View', styles.divider

			wrapper.add @renderLabel label, width, index++
		@

	renderLabel: (label, width, index) =>

		wrapper = @make 'View', styles.label.inactive,
			width: "#{width}%"

		text = if _.isString label
			label
		else
			label.title

		labelView = @make 'Label', styles.label.text,
			text: text

		if _.isObject(label) && label.icon?
			wrapper.add @make 'View', styles.label.icon,
				backgroundImage: label.icon

			# offset the label for the icon
			labelView.left = 20
		
		wrapper.add labelView

		updateState= =>

			if index is @presenter.get 'currentIndex'
				wrapper.backgroundGradient = styles.label.active.backgroundGradient
			else
				wrapper.backgroundGradient = styles.label.inactive.backgroundGradient

		@bindTo @presenter, 'change:currentIndex', updateState

		updateState()

		wrapper.addEventListener 'click', =>

			@presenter.set
				currentIndex: index

			# this appears not to work...
			@trigger 'click', index

			return

		wrapper
