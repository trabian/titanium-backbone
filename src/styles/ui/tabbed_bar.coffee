borderWidth = 3

module.exports = 
	view:
		layout: 'horizontal'
		height: 30 + (borderWidth * 2)
		width: Ti.UI.FULL
		borderWidth: borderWidth
		borderRadius: borderWidth
		borderColor: "#eeeeee"
		backgroundColor: "#eeeeee"
	wrapper:
		layout: 'horizontal'
		left: borderWidth
		top: borderWidth
		right: borderWidth
		bottom: borderWidth
		borderRadius: 4
		borderWidth: 1
		height: 30
		borderColor: "#ababab"
	label:
		text:
			textAlign: 'center'
			font:
				fontSize: 13
				fontColor: '#333333'
			shadowColor: '#ffffff'
			shadowOffset: {x:1,y:1}
		icon:
			width: 16
			height: 16
			left: 4
		inactive:
			#backgroundColor: '#eee'
			backgroundGradient:
				type: 'linear'
				startPoint:
					x: 0
					y: 0
				endPoint:
					x: 0
					y: '100%'
				colors: [
					{ color: '#eee', offset: 0.0 },
					{ color: '#eee', offset: 1.0 }
				]
		active:
			#backgroundColor: '#ababab'
			backgroundColor: '#eee'
			backgroundGradient:
				type: 'linear'
				startPoint:
					x: 0
					y: 0
				endPoint:
					x: 0
					y: '100%'
				colors: [
					{ color: '#ababab', offset: 0.0 },
					{ color: '#eee', offset: 1.0 }
				]
	divider:
		backgroundColor: '#ababab'
		width: 1
		top: 0
		bottom: 0